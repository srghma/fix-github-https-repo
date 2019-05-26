module NormalizeUrlSpec (spec) where

import "protolude" Protolude

import "hspec"   Test.Hspec
import "quickcheck-instances" Test.QuickCheck.Instances.Text
                                                ( )

import           FixGithubHttpsRepo

normalizedUrlShouldBe :: Url -> Text -> SpecWith ()
normalizedUrlShouldBe urlObj expectedUrlText = it
  (toS expectedUrlText)
  (normalizeUrl urlObj `shouldBe` expectedUrlText)

spec :: Spec
spec = do
  normalizedUrlShouldBe
    (Url
      { host     = "github.com"
      , port     = Nothing
      , username = "myusername"
      , repo     = "myproject"
      }
    )
    "ssh://git@github.com/myusername/myproject.git"
  normalizedUrlShouldBe
    (Url
      { host     = "github.com"
      , port     = Just 4242
      , username = "myusername"
      , repo     = "myproject"
      }
    )
    "ssh://git@github.com:4242/myusername/myproject.git"
