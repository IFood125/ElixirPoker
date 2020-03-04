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

    def royalFlush?(hand)do
        case hand do
            [1,10,11,12,13] -> true
            [27,36,37,38,39] -> true
            [14,23,24,25,26] -> true
            [40,49,50,51,52] -> true
            _ -> false
        end
    end

    def double(hand) do
        hand|> Enum.group_by(&(&1))|> Enum.filter(fn {_, [_,_|_]} -> true; _ -> false end)|> Enum.map(fn {x, _} -> x end)
    end
    def flush?(hand) do
        range1 = 1..13
        range2 = 14..26
        range3 = 27..39
        range4 = 40..52
        Enum.all?(hand, fn num -> Enum.member?(range1,num) end) ||
        Enum.all?(hand, fn num -> Enum.member?(range2,num) end) ||
        Enum.all?(hand, fn num -> Enum.member?(range3,num) end) ||
        Enum.all?(hand, fn num -> Enum.member?(range4,num) end)
        
        
    end
end
