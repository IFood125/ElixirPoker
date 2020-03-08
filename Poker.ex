defmodule Poker do
    def deal(list) do
        left = Enum.sort([] ++ [Enum.at(list,0)] ++ [Enum.at(list,2)] ++ [Enum.at(list,4)] ++ [Enum.at(list,6)] ++ [Enum.at(list,8)])
        right = Enum.sort([] ++ [Enum.at(list,1)] ++ [Enum.at(list,3)] ++ [Enum.at(list,5)] ++ [Enum.at(list,7)] ++ [Enum.at(list,9)])
        
    end
    #Sorts the hand keeping it as integers from 1-52
    def sort(hand)do
        Enum.sort(hand)
    end
    def remSort(hand) do
        sort(Enum.map(hand, fn num -> rem(num, 13) end))

    end

    def straight?([1,2,3,4,5]) do
        true
    end

    def straight?([0,1,10,11,12])do
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

    def straightFlush?(hand)do
        not royalFlush?(hand) and straight?(sort(hand)) and flush?(hand)
    end
    def fourOfAKind?(hand) do
        length(quad(hand)) > 0
    end
    def fullHouse?(hand) do
        (length(triple(hand)) > 0) and (length(double(hand)) > 0)
    end
    def threeOfAKind?(hand) do
        length(triple(hand)) > 0
    end
    def twoPair?(hand) do
        length(double(hand))  == 2
    end
    def pair?(hand) do
        length(double(hand))  == 1
    end
    def double(hand) do
        hand|> Enum.group_by(&(&1))|> Enum.filter(fn {_, [_,_]} -> true; _ -> false end)|> Enum.map(fn {x, _} -> x end)
    end
    
    def triple(hand) do
        hand|> Enum.group_by(&(&1))|> Enum.filter(fn {_, [_,_,_]} -> true; _ -> false end)|> Enum.map(fn {x, _} -> x end)
    end
    
    def quad(hand) do
        hand|> Enum.group_by(&(&1))|> Enum.filter(fn {_, [_,_,_,_]} -> true; _ -> false end)|> Enum.map(fn {x, _} -> x end)
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
    def ranking(hand) do
        _rf = royalFlush?(hand)
        _foak = fourOfAKind?(hand)
        _fh = fullHouse?(hand) 
        _f = flush?(hand) 
        _s = straight?(hand) 
        _toak = threeOfAKind?(hand)
        _tp = twoPair?(hand) 
        _p = pair?(hand) 

        case true do
            _rf -> 10
            _foak  -> 9
            _fh -> 8
            _f -> 7
            _s -> 6
            _toak  -> 5
            _tp -> 4
            _tp  -> 3
            _p -> 2
            _ -> 1
        end
    end
#compare 2 royal-flush hands:
    def compare10(hand1,hand2) do
        x = Enum.at(hand1,0)
        y = Enum.at(hand2,0)
        cond do
            x > y -> hand1
            y > x -> hand2
        end
    end
    #compare 2 hands with 4 of a kinds:
    def compare9(hand1,hand2) do
        
        x = remSort(hand1)|> Enum.group_by(&(&1))|> Enum.filter(fn {_, [_,_,_,_]} -> true; _ -> false end)|> Enum.map(fn {x, _} -> x end) |> Enum.at(0)
        y = remSort(hand2)|> Enum.group_by(&(&1))|> Enum.filter(fn {_, [_,_,_,_]} -> true; _ -> false end)|> Enum.map(fn {x, _} -> x end) |> Enum.at(0)
        cond do
            x == 1 -> hand1
            y == 1 -> hand2
            x == 0 -> hand1
            y == 0 -> hand2
            x > y -> hand1
            y > x -> hand2
        end
    end
    #compare 2 full house hands
    def compare8(hand1,hand2) do
        t1 = remSort(hand1) |> Enum.group_by(&(&1))|> Enum.filter(fn {_, [_,_,_]} -> true; _ -> false end)|> Enum.map(fn {x, _} -> x end) |> Enum.at(0)
        t2 = remSort(hand2) |> Enum.group_by(&(&1))|> Enum.filter(fn {_, [_,_,_]} -> true; _ -> false end)|> Enum.map(fn {x, _} -> x end) |> Enum.at(0)
        
        cond do
            t1 == 1 -> hand1
            t2 == 1 -> hand2
            t1 == 0 -> hand1
            t2 == 0 -> hand2
            t1 > t2 -> hand1
            t2 > t1 -> hand2
        end
    end

    def findHighestCard(hand) do
        lst = remSort(hand)
        case lst do
            [1,2,3,4,5] -> 5
            [0,1,10,11,12] -> 1
            [0,9,10,11,12] -> 0
            _ -> Enum.at(lst,4)
        end
    
    end

    #compare suits of 2 cards have the same ranks (9C vs 9H)
    #parameter: r is the card rank or the rem(card,13)
    def compareSuit(r, hand1,hand2) do
        elem1 = Enum.find(hand1, fn x -> rem(x,13) == r end)
        elem2 = Enum.find(hand2, fn x -> rem(x,13) == r end)
        cond do 
            elem1 > elem2 -> hand1
            elem2 > elem1 -> hand2
        end
    end

    #compare 2 straight hands
    def compare5(hand1,hand2) do
        c1 = findHighestCard(hand1)
        c2 = findHighestCard(hand2)
        
        cond do
            c2 == c1 -> compareSuit(c1,hand1,hand2)
            c1 == 1 -> hand1
            c2 == 1 -> hand2
            c1 == 0 -> hand1
            c2 == 0 -> hand2
            c1 > c2 -> hand1
            c2 >c1 -> hand2
            
        end     
    end
end
