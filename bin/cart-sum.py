#!/usr/bin/env python3

# Outputs all combinations of prices in xs that sum to n.

# https://stackoverflow.com/questions/62009846/all-possible-change-combinations
n = 603
xs = [149,119,109,99,89,79,65,59]
sols = []

def possible_change(n, p=[]):
    global coins
    if n == 0:
        global sols
        sols.append(p)
    else:
        for c in xs:
            if n - c >= 0:
                possible_change(n-c, p+[c])    

possible_change(n)
print('Solutions to sum to', n, 'with', xs)
# print(len(sols))
sols = set(map(tuple, (map(sorted, sols))))
# print(sols)
from itertools import groupby
for s in sols:
    # print(s)
    g = [(k, sum(1 for i in g)) for k,g in groupby(s)]
    print(g)
    # print(' + '.join([f'{n}*{k}' for k,n in g]))

# https://en.wikipedia.org/wiki/Packing_problems
# https://en.wikipedia.org/wiki/Subset_sum_problem
# https://en.wikipedia.org/wiki/Change-making_problem

# https://p-library.com/o/coin/
# https://www.geeksforgeeks.org/generate-a-combination-of-minimum-coins-that-results-to-a-given-value/
