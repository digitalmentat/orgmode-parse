-----------------------------------------------------------------------------
-- |
-- Module      :  Data.OrgMode.Parse.Attoparsec.Section
-- Copyright   :  © 2015 Parnell Springmeyer
-- License     :  All Rights Reserved
-- Maintainer  :  Parnell Springmeyer <parnell@digitalmentat.com>
-- Stability   :  stable
--
-- Parsing combinators for org-mode headline sections.
----------------------------------------------------------------------------



module Data.OrgMode.Parse.Attoparsec.Section where

import           Control.Applicative                  ()
import           Data.Attoparsec.Text                 (skipSpace, many', option)
import qualified Data.Attoparsec.Text                 as Attoparsec.Text
import           Data.Monoid                          ()

import           Data.OrgMode.Parse.Attoparsec.Drawer
import           Data.OrgMode.Parse.Attoparsec.Time
import           Data.OrgMode.Parse.Attoparsec.Util          (skipEmptyLines)
import           Data.OrgMode.Parse.Attoparsec.Block         (parseBlocks)
import           Data.OrgMode.Types

-- | Parse a heading section
--
-- Headline sections contain optionally a property drawer,
-- a list of clock entries, code blocks (not yet implemented),
-- plain lists (not yet implemented), and unstructured text.
parseSection :: Attoparsec.Text.Parser Section
parseSection = skipEmptyLines *> parseSection' <* skipEmptyLines
  where
  parseSection' = Section
   <$> option Nothing (Just <$> (skipSpace *> parseTimestamp <* skipSpace))
   <*> (Plns <$> parsePlannings)
   <*> many' parseClock
   <*> option mempty parseProperties
   <*> option mempty parseLogbook
   <*> parseBlocks

