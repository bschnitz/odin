# frozen_string_literal: true

# left / right determine the current part of the array to be used
# using theses "pointers" instead of slices saves some memory
def merge_sort(array, left = 0, right = array.length - 1)
  return [array[left]] if left == right

  l_arr = merge_sort(array, left, left + (right - left) / 2)
  r_arr = merge_sort(array, left + (right - left) / 2 + 1, right)

  merged_array = []
  merged_array.push(l_arr[0] < r_arr[0] ? l_arr.shift : r_arr.shift) while
    !l_arr.empty? && !r_arr.empty?
  merged_array.push(*l_arr, *r_arr)
end

array = (0..10).to_a.shuffle
p array
p merge_sort(array)
p merge_sort([0, 3, 5, 0, 5, 4, 3])
p merge_sort([3])
