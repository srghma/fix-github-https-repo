module Utils (showT) where

import "protolude" Protolude

import qualified "base"    GHC.Show (Show (..))
import qualified "text"    Data.Text

showT :: (Show a) => a -> Text
showT = Data.Text.pack . GHC.Show.show

-- traceShowIdWithPrefix :: forall a. Show a => Text -> a -> a
-- traceShowIdWithPrefix prefix a = trace (prefix <> showT a) a
