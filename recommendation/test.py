import json


import numpy as np


# x = '{ "name":"John", "age":30, "city":"New York"}'
# z = '{ "name":"mook", "age":22, "city":"Thailand"}'

# # parse x:
# y = [1,2]
# y.append(x)
# for i in range(2):
#     print(i)
# y.append(json.loads(z))
# # the result is a Python dictionary:
# print(y)

# final1 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
# data = '{ "name":"John", "age":30, "city":"New York"}'
# data2 = '{ "name":"mook", "age":22, "city":"Thailand"}'

# b = np.where in (final1)

# final1.append(data)
# final1.append(data2)
# final = json.dumps(final1)
# print(final1)
# print(b)

jsonStr = '{"a":1, "b":2}'
# aList = json.loads(jsonStr)
# print(aList)

a = np.arange(10)
print(a)
alist = [0, 1, 2, 3, 4]
# b = np.where(aList)
b1 = np.where(a)
print(np.where(a < 50))
# print(b)
print(b1)