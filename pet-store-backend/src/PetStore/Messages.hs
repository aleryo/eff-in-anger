{-# LANGUAGE DeriveAnyClass        #-}
{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE GADTs                 #-}
{-# LANGUAGE NamedFieldPuns        #-}
{-# LANGUAGE TemplateHaskell       #-}
module PetStore.Messages
  ( PetType(..), Pet(..), User(..), Input(..), Output(..), PetStoreError(..)
  , module Payment
  ) where

import           Data.Aeson
import           GHC.Generics
import           PetStore.Payment.Types as Payment

data PetType = Cat | Dog | Canary | Fish | Rabbit
  deriving (Eq, Show, Enum,Generic,ToJSON,FromJSON)

data Pet = Pet { petName  :: String
               , petType  :: PetType
               , petPrice :: Integer
               }
           deriving (Eq,Show,Generic,ToJSON,FromJSON)

data User = User { userName :: String }
          deriving (Eq,Ord,Show,Generic,ToJSON,FromJSON)

-- rename back to Input / Output
data Input = -- Commands
             Add { pet :: Pet }
           | Remove { pet :: Pet }
             -- level2: Checkout
           | UserLogin { user :: User }
           | AddToBasket { user :: User, pet :: Pet }
           | RemoveFromBasket { user :: User, pet :: Pet }
           | CheckoutBasket { user :: User, payment :: Payment }
           | UserLogout { user :: User }
             -- level3: AddAccessory/RemoveAccessory w/ constraints depending on type of pet
             -- Queries
           | ListPets
           | GetUserBasket { user :: User }
  deriving (Eq, Show,Generic,ToJSON,FromJSON)

data Output = -- Events
              PetAdded { pet :: Pet }
            | PetRemoved { pet :: Pet }
            | UserLoggedIn { user :: User }
            | AddedToBasket { user :: User, pet :: Pet }
            | RemovedFromBasket { user :: User, pet :: Pet }
            | CheckedOutBasket { user :: User, payment :: Payment, amount :: Integer }
            | UserLoggedOut { user :: User }
            -- Answers
            | UserBasket { user :: User, pets :: [ Pet ] }
            | Pets { pets :: [ Pet ] }
            | Error { reason :: PetStoreError }
  deriving (Eq, Show,Generic,ToJSON,FromJSON)

-- some errors
data PetStoreError = PetAlreadyAdded
                   | PetDoesNotExist
                   | UserNotLoggedIn
                   | PetNotInBasket
                   | InvalidPayment
  deriving (Eq, Show,Generic,ToJSON,FromJSON)
