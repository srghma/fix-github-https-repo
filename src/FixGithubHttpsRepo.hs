module FixGithubHttpsRepo (
  Url (..),
  parseUrl,
  normalizeUrl
                          ) where

import "protolude" Protolude

import "regex"    Text.RE.TDFA.Text                   as TDFA
import qualified "base"    GHC.Show
-- import "prettyprinter"    Data.Text.Prettyprint.Doc (Pretty (..))
-- import qualified "prettyprinter"    Data.Text.Prettyprint.Doc

data Url =
  Url
    { host     :: !Text
    , port     :: !(Maybe Int)
    , username :: !Text
    , repo     :: !Text
    }
  deriving (Show, Eq)

-- instance Pretty Url where
--   pretty = Data.Text.Prettyprint.Doc.viaShow

-- http://engineers.irisconnect.net/posts/2017-03-07-regex.html

parseUrl :: Text -> Maybe Url
parseUrl url
  | length subgroups1 == 3 = do
  -- | length (traceShowIdWithPrefix "subgroups1:"  subgroups1) == 3 = do
    host <- subgroups1 `atMay` 0
    username <- subgroups1 `atMay` 1
    repo <- subgroups1 `atMay` 2
    return
      (Url
        { host     = host
        , port     = Nothing
        , username = username
        , repo     = repo
        }
      )
  | length subgroups2 == 5 = do
  -- | length (traceShowIdWithPrefix "subgroups2:"  subgroups2) == 5 = do
    host <- subgroups2 `atMay` 1
    port <- subgroups2 `atMay` 2 >>= parseInteger
    username <- subgroups2 `atMay` 3
    repo <- subgroups2 `atMay` 4
    return
      (Url
        { host     = host
        , port     = (Just port)
        , username = username
        , repo     = repo
        }
      )
  | length subgroups3 == 4 = do
  -- | length (traceShowIdWithPrefix "subgroups3:"  subgroups3) == 4 = do
    host <- subgroups3 `atMay` 1
    username <- subgroups3 `atMay` 2
    repo <- subgroups3 `atMay` 3
    return
      (Url
        { host     = host
        , port     = Nothing
        , username = username
        , repo     = repo
        }
      )
  | otherwise = Nothing
  where
    subgroups1 = url `matchSubgroups` [re|https://(.*)/(.*)/(.*)|]
    subgroups2 = url `matchSubgroups` [re|(ssh://)?git@(.*):([0-9]+)/(.*)/(.*).git|]
    subgroups3 = url `matchSubgroups` [re|(ssh://)?git@(.*)[:/](.*)/(.*).git|]
    text `matchSubgroups` regex = subgroups
      where (_before, _match, _after, subgroups) = (text =~ regex) :: (Text, Text, Text, [Text])

normalizeUrl :: Url -> Text
normalizeUrl (Url { .. }) = "ssh://git@" <> host <> (maybe "" (\portInt -> ":" <> (toS . GHC.Show.show $ portInt)) port) <> "/" <> username <> "/" <> repo <> ".git"
