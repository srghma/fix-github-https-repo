module Main (main) where

import "protolude" Protolude             hiding ( stdout
                                                , (%)
                                                , die
                                                )
import "turtle"  Turtle
import qualified "base" Data.Char
import qualified "text" Data.Text
import qualified "prettyprinter"    Data.Text.Prettyprint.Doc as PP
import qualified "prettyprinter-ansi-terminal"    Data.Text.Prettyprint.Doc.Render.Terminal as PP

import FixGithubHttpsRepo

-- TODO: use https://hackage.haskell.org/package/optparse-applicative
-- TODO: use https://github.com/tfausak/flow

parser :: Parser (Maybe Text, Maybe Int, Bool)
parser = (,,) <$> optional (optText "remote" 'r' "The `git remote` you want to convert (default - origin)")
              <*> optional (optInt "port" 'p' "The expected ssh port of new url")
              <*> switch "unset-port" 'u' "Remote port from new url, cannot be used with --port option"

notSpace :: Pattern Char
notSpace = satisfy $ not . Data.Char.isSpace

notSpaces :: Pattern Text
notSpaces = star notSpace

notSpaces1 :: Pattern Text
notSpaces1 = plus notSpace

main :: IO ()
main = do
  (maybeRemoteName, maybeNewPort, doRemovePort) <- options "Converts https git remote to ssh (e.g. https://github.com/myusername/myrepo to ssh://git@github.com/myusername/myrepo.git)" parser

  when (doRemovePort && isJust maybeNewPort) (die "--port and --unset-port are self-excluding")

  let remoteName = maybe "origin" identity maybeRemoteName

  -- executes
  -- git remote -v | grep -m1 '^origin' | sed -Ene's#.*(https://[^[:space:]]*).*#\1#p'
  remoteUrl <- fmap Data.Text.strip . strict $
    inproc "git" ["remote", "-v"] empty &
    grep (prefix (text remoteName)) &
    limit 1 &
    sed (between (suffix $ notSpaces <> spaces1) (prefix $ spaces1 <> notSpaces) notSpaces1)

  when (Data.Text.null remoteUrl) (die $ "Url for " <> remoteName <> " not found")

  PP.putDoc $ PP.annotate (PP.color PP.Blue) ("Current " <> PP.pretty remoteName <> " remote url:    ") <> PP.pretty remoteUrl <> PP.line

  let maybeParsedUrlObj = parseUrl remoteUrl
  -- printf ("maybeParsedUrlObj=" % w % "\n") maybeParsedUrlObj

  parsedUrlObj <- maybe (die $ "Invalid url for " <> remoteName <> ": " <> remoteUrl) return maybeParsedUrlObj

  -- printf ("parsedUrlObj=" % w % "\n") parsedUrlObj

  let parsedUrlObj' = parsedUrlObj
        { port = if doRemovePort
                   then Nothing
                   else case maybeNewPort of
                     Just newPort -> Just newPort
                     Nothing      -> port parsedUrlObj
        }

  -- printf ("parsedUrlObj'=" % w % "\n") parsedUrlObj'

  let normalizedUrl = normalizeUrl parsedUrlObj'
  PP.putDoc $ PP.annotate (PP.color PP.Blue) ("Normalized " <> PP.pretty remoteName <> " remote url: ") <> PP.pretty normalizedUrl <> PP.line

  if normalizedUrl == remoteUrl
    then printf "Url not changed\n"
    else (do
      procs "git" ["remote", "set-url", remoteName, normalizedUrl] empty
      printf "Url changed\n"
    )
