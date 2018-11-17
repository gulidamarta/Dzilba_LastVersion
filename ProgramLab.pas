body
{
    /* Раскомментируйте это, чтобы включить прокрутку и масштабирование
  действие касания: операция;
  */
    /**
 * The developer of the object is a sorter that allows sorting integer arrays
 * in at least 4 ways.
 */
    var arraySorter;
    arraySorter = function ()
    {
        return
        {
            bubbleSort: function(array)
            {
                for (var i = 0; i < array.length; i++)
                {
                    for (var j = 0; j < array.length - i - 1; j++)
                    {
                        if (array[j] > array[j+1])
                        {
                            var temp = array[j];
                            array [j] = array[j+1];
                            array [j+1] = temp;
                        }
 
                    }
                }
 
                return array;
            },
 
            merge: function(left, right)
            {
                var array_result = [],
                leftIndex = 0,
                rightIndex = 0;
 
                while (leftIndex < left.length && rightIndex < right.length)
                {
                    if (left[leftIndex] > right[rightIndex])
                    {  
                        array_result .push(right[rightIndex]);
                        rightIndex ++;
                    }
                    else
                    {
                        array_result .push(left[leftIndex]);
                        leftIndex ++;
                    }
 
                }  
 
                while (leftIndex < left.length)
                {
                    array_result .push(left[leftIndex]);
                    leftIndex ++;
                }
 
                while (rightIndex < right.length)  
                {
                    array_result .push(right[rightIndex]);
                    rightIndex ++;
                }
 
                return array_result;
            },
 
            mergeSort: function(array)
            {
                if (array.length === 1 )
                {
                    return array;
                }          
 
                var mid = parseInt(array.length / 2),
                    left = array.slice(0, mid),
                    right = array.slice(mid);
 
                    return arraySorter.merge(arraySorter.mergeSort(left), arraySorter.mergeSort(right));
            },
 
            insertionSort: function(array)
            {
                for (var i = 0; i < array.length; i++)
                {
                    var temp = array[i];
                    for (var j = i - 1; j >= 0 && array[j] > temp; j--)
                    {
                        array [j+1] = array[j];
                    }
 
                    array[j+1] = temp;
                }
 
                return array;
            },
 
            bucketSort: function(array, bucketSize)
            {
                if (array.length === 0)
                {
                    return array;
                }
 
                var minValue = array[0],
                    maxValue = array[0];
 
                for (var i = 1; i < array.length; i++)
                {
                    if (array[i] < minValue)
                    {
                        minValue = array[i];
                    }
                    else
                    if (array[i] > maxValue)
                    {
                        maxValue = array[i];
                    }
 
                }
 
                var DEFAULT_BUCKET_SIZE = 10;
                bucketSize = bucketSize || DEFAULT_BUCKET_SIZE;
                var bucketCount = Math.floor((maxValue - minValue) / bucketSize) + 1,
                    buckets = new Array(bucketCount);
                for (i = 0; i < buckets.length; i++)
                {
                    buckets [i] = [];  
                }
 
                for (i = 0; i < array.length; i++)
                {
                    buckets [Math.floor((array[i] - minValue) / bucketSize)].push(array[i]);
                }
 
                array.length = 0;
                for (i = 0; i < buckets.length; i++)
                {
                    arraySorter .insertionSort(buckets[i]);
                    for (var j = 0; j < buckets[i].length; j++)
                    {
                        array .push(buckets[i][j]);
                    }
                }
 
                return array;
            },
 
            swap: function(array, leftIndex, rightIndex)
            {
                var temp = array[leftIndex];
                    array [leftIndex] = array[rightIndex];
                    array [rightIndex] = temp;
            },
 
            partition: function(array, left, right)
            {
                var index = Math.floor((right + left) / 2),
                    pivot = array[index],
                    i = left, j = right;
 
                while (i < j)
                {
                    while (array[i] < pivot)
                    {
                        i ++;
                    }
 
                    while (array[j] > pivot)
                    {
                        j--;
                    }
 
                    if (i < j)
                    {
                        arraySorter .swap(array, i, j);
                        if (i === index)
                        {
                            index = j;
                        }
                        else
                        if (j === index)
                        {
                            index = i;
                        }
                        i + +; j--;
                    }
                }
                return i;
            },
 
            quickSort: function(array, left, right) {
            var index;
 
            if (array.length > 1)
 
            {
                left = typeof left !== "number" ? 0 : left;
                right = typeof right !== "number" ? array.length - 1 : right;
 
                index = arraySorter.partition(array, left, right);
 
                if (left < index - 1)
                {
                    arraySorter .quickSort(array, left, index - 1);
                }
                if (index + 1 < right)
                {
                    arraySorter .quickSort(array, index + 1, right);
                }          
            }
 
            return array;
        }
    }  
}
();
console.log(arraySorter.bubbleSort([1, 5, 3, 2]));
console.log(arraySorter.mergeSort([1, 5, 3, 2, 7, 6]));
console.log(arraySorter.bucketSort([1, 5, 3, 2]));
console.log(arraySorter.quickSort([1, 5, 3, 2, 7, 6], 0, 5));
 
}