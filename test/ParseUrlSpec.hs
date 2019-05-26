module ParseUrlSpec (spec) where

import "protolude" Protolude

import "hspec"   Test.Hspec
import "quickcheck-instances" Test.QuickCheck.Instances.Text
                                                ( )

import           FixGithubHttpsRepo

parsedShouldBe :: Text -> Maybe Url -> SpecWith ()
parsedShouldBe url expected = it
  (toS url)
  (parseUrl url `shouldBe` expected)

spec :: Spec
spec = do
  parsedShouldBe
    "https://github.com/myusername/myproject"
    (Just Url
      { host     = "github.com"
      , port     = Nothing
      , username = "myusername"
      , repo     = "myproject"
      }
    )
  parsedShouldBe
    "https://gitlab.mycompany.com/myusername/myproject"
    (Just Url
      { host     = "gitlab.mycompany.com"
      , port     = Nothing
      , username = "myusername"
      , repo     = "myproject"
      }
    )
  parsedShouldBe
    "ssh://git@gitlab.mycompany.com:4242/myusername/myproject.git"
    (Just Url
      { host     = "gitlab.mycompany.com"
      , port     = Just 4242
      , username = "myusername"
      , repo     = "myproject"
      }
    )
  parsedShouldBe
    "git@github.com:myusername/myproject.git"
    (Just Url
      { host     = "github.com"
      , port     = Nothing
      , username = "myusername"
      , repo     = "myproject"
      }
    )
  parsedShouldBe
    "git@gitlab.mycompany.com:4242/myusername/myproject.git"
    (Just Url
      { host     = "gitlab.mycompany.com"
      , port     = Just 4242
      , username = "myusername"
      , repo     = "myproject"
      }
    )
