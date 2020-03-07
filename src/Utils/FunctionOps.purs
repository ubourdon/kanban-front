module Utils.FunctionOps ( thrush, (|>) ) where
  
thrush :: forall a b. a -> (a -> b) -> b
thrush x y = y x

infixl 8 thrush as |>  