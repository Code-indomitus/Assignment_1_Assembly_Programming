"""
Documented and commented by Shyam Kamalesh Borkar.
"""


def print_combination(arr, n, r):

    data = [0] * r
 
    combination_aux(arr, n, r, 0, data, 0)
 
def combination_aux(arr, n, r, index, data, i):

    if (index == r):
        for j in range(r):
            print(data[j], end = " ")
        print()
        return
 
    if (i >= n):
        return
 
    data[index] = arr[i]
    combination_aux(arr, n, r, index + 1,
                    data, i + 1)
 
    combination_aux(arr, n, r, index,
                    data, i + 1)
 
def main():
    arr = [1, 2, 3, 4, 5]
    r = 3
    n = len(arr)
    print_combination(arr, n, r)

main()