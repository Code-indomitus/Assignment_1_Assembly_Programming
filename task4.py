"""
Documented and commented by Shyam Kamalesh Borkar.
This file contains an insertion_sort function that sorts an input list in ascending order.
"""
from typing import List, TypeVar

T = TypeVar('T')

def insertion_sort(the_list: List[T]):
    length = len(the_list)                     # Length of the_list
    for i in range(1, length):                 # iterate through every item in the list 
        key = the_list[i]                      # key is the i-th element of the_list
        j = i-1                                # j is one lesser than i
        while j >= 0 and key < the_list[j] :   # compare new item to items on the left of the array
                the_list[j + 1] = the_list[j]  # go through each values in sorted array and place key at position based on condition
                j -= 1                         # decrement j to go to the next element to the left
        the_list[j + 1] = key                  # position for insertion found and key value inserted

def main() -> None:
    arr = [6, -2, 7, 4, -10]                   # create arr
    insertion_sort(arr)                        # call insertion_sort on array
    for i in range(len(arr)):                  # loop for printing elements of arr
        print (arr[i], end=" ")                # print all values in the sorted array on the same line with a space as the separtlr
    print()


main()                                        # call main function