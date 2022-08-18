"""
Documented and commented by Shyam Kamalesh Borkar.
There are two functions print_combination and combination_aux.
print_combination takes in 3 arguments - arr, n, r
combination_aux takes in 6 arguments - arr, n, r, index, data, i
The function print_combination calls combination_aux after creating arr with r elements of zero.
combination_aux prints all the possible combinations of elements in arr with a length of r.
Essentially printing out all the combinations for elements in arr -> len(arr) - Combination - r
"""


def print_combination(arr, n, r):

    data = [0] * r        # create data list with r zero elements
 
    combination_aux(arr, n, r, 0, data, 0) # call combination_aux with index and i set to zero.
 
def combination_aux(arr, n, r, index, data, i):

    if (index == r):          # Check if index is equal to r
        for j in range(r):    # if true iterate through data and print the elements
            print(data[j], end = " ")
        print()
        return
 
    if (i >= n):              # if i greater then or equal to n then return 
        return
 
    data[index] = arr[i]      # the index-th element of date is equal to the i-th element of arr.
    combination_aux(arr, n, r, index + 1, 
                    data, i + 1)       # calls combination_aux with an incremented index and an incremented i
 
    combination_aux(arr, n, r, index,
                    data, i + 1)       # calls combination_aux with an incremented i
 
def main():
    arr = [1, 2, 3, 4, 5]        # create arr
    r = 3                        # set r
    n = len(arr)                 # get length of arr
    print_combination(arr, n, r) # call print_combination

main()