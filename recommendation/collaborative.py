import pandas as pd
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.metrics import pairwise_distances
from sklearn.model_selection import train_test_split

# g = "/recommendation/rating_final.csv"
# df_restaurant = pd.read_csv(g)
df_restaurant = pd.read_csv("C:/Users/User/Desktop/Project/Project/Git/rating_final.csv")
df_restaurant_cuisine = pd.read_csv('C:/Users/User/Desktop/Project/Project/Git/chefmozcuisine.csv')
# print(df_restaurant.head(10))
# print(df_restaurant_cuisine.head(10))

x_train, x_test = train_test_split(df_restaurant, test_size = 0.30, random_state = 42)
# print(x_train.shape)
# print(x_test.shape)

user_data = x_train.pivot(index = 'userID', columns = 'placeID', values = 'rating').fillna(0)
# print(user_data.head())

dummy_train = x_train.pivot(index = 'userID', columns = 'placeID', values = 'rating').fillna(0)
# print(dummy_train.head())

dummy_test = x_test.pivot(index = 'userID', columns = 'placeID', values = 'rating').fillna(1)
# print(dummy_test.head())

test = user_data
test['user_index'] = np.arange(0, dummy_train.shape[0],1)
# print(test.head())

test.set_index(['user_index'], inplace = True)
# print(test.head())

user_similarity = cosine_similarity(test)
user_similarity[np.isnan(user_similarity)] = 0
# print(user_similarity)
# print(user_similarity.shape)

user_predicted_ratings = np.dot(user_similarity, test)
# print(user_predicted_ratings)

user_final_ratings = np.multiply(user_predicted_ratings, dummy_train)
# print(user_final_ratings.head())

print(user_final_ratings.iloc[1].sort_values(ascending = False)[0:10])

print(user_final_ratings.iloc[136].sort_values(ascending = False)[0:10].keys().to_list())

#//Evaluation

# test_user_features = x_test.pivot(index = 'userID', columns = 'placeID', values = 'rating').fillna(0)
# test_user_similarity = cosine_similarity(test_user_features)
# test_user_similarity[np.isnan(test_user_similarity)] = 0

# print(test_user_similarity)
# print("- "*10)
# print(test_user_similarity.shape)

# user_predicted_ratings_test = np.dot(test_user_similarity, test_user_features)
# user_predicted_ratings_test

# test_user_final_rating = np.multiply(user_predicted_ratings_test, dummy_test)
# print(test_user_final_rating.head())

# from sklearn.preprocessing import MinMaxScaler

# X = test_user_final_rating.copy() 
# X = X[X > 0] # only consider non-zero values as 0 means the user haven't rated the movies

# scaler = MinMaxScaler(feature_range = (0.5, 5))
# scaler.fit(X)
# pred = scaler.transform(X)

# print(pred)

# total_non_nan = np.count_nonzero(~np.isnan(pred))
# print(total_non_nan)

# test = x_test.pivot(index = 'userID', columns = 'placeID', values = 'rating')
# print(test.head())

# mae = np.abs(pred - test).sum().sum()/total_non_nan
# print(mae)

# diff_sqr_matrix = (test - pred)**2
# sum_of_squares_err = diff_sqr_matrix.sum().sum() 
# rmse = np.sqrt(sum_of_squares_err/total_non_nan)
# print(rmse)