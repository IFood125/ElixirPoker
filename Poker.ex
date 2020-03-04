defmodule Poker do

    def sort(hand) do
        Enum.sort(Enum.map(hand, fn num -> rem(num, 13) end))

    end

    def straight?([1,2,3,4,5]) do
        true
    end

    def straight?([1,10,11,12,13])do
        true
    end
    def straight?(hand) when length(hand) > 1 do
        (hd hand) == (hd (tl hand)) - 1 and straight?(tl hand)
    end
    def straight?([_]) do
        true
    end

    def flush?(hand) do
    end
end
