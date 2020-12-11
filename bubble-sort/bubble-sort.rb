#!/urs/bin/ruby

def bubble_sort(arr)
  begin
    swapped = false
    for j in 0...arr.length-1
      if arr[j] > arr[j+1]
        arr[j], arr[j+1] = [arr[j+1], arr[j]]
        swapped = true
      end
    end
  end while swapped
  arr
end

p bubble_sort([4,3,78,2,0,2])
