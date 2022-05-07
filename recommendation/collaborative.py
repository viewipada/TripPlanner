# df = pd.DataFrame.from_records(data_code)
#     df.to_csv(index=False)
#     # print("df = ",df.head(10))

#     df = df.drop(df.columns[4:], axis=1)
#     # print("df delete = ",df.head(10))

#     df_melt = df.melt(id_vars="userId", var_name="activity")
#     # print("df_melt = ",df_melt.head(10))
#     x_train, x_test = train_test_split(
#         df_melt, test_size=0.30, random_state=42)

#     user_data = x_train.pivot(
#         index='userId', columns='activity', values='value').fillna(0)
#     dummy_train = x_train.pivot(
#         index='userId', columns='activity', values='value').fillna(0)
#     # print("user_data = ",user_data.head(10))

#     dummy_test = x_test.pivot(
#         index='userId', columns='activity', values='value').fillna(1)

#     cosine = cosine_similarity(dummy_train)
#     np.fill_diagonal(cosine, 0)
#     similarity_with_user = pd.DataFrame(cosine, index=dummy_train.index)
#     similarity_with_user.columns = dummy_train.index
#     # similarity_with_user.head(10)

#     def find_n_neighbours(df, n):
#         order = np.argsort(df.values, axis=1)[:, :n]
#         df = df.apply(lambda x: pd.Series(x.sort_values(ascending=False)
#                                           .iloc[:n].index,
#                                           index=['top{}'.format(i) for i in range(1, n+1)]), axis=1)
#         return df

#     sum_i = 5
#     status = 0
#     g = 1
#     final_list = []

#     sim_user = find_n_neighbours(similarity_with_user, len(data_user_interest))
#     # print("data_user_interest = ",len(data_user_interest),len(sim_user))#++ptint importan
#     all_sim = sim_user.iloc[user_id][:].to_list()
#     # for i in range(5):
#     #     sim_user.append(72)

#     # print("sim_user = ", len(all_sim))#++ptint importan

#     while len(final_list) < 10 and sum_i < len(all_sim):
#         # print("sum_i = ",sum_i)#++ptint importan
#         user_id = user_id - 1
#         if len(final_list) < 10 and status == 1:
#             user = sim_user.iloc[user_id][sum_i-1:sum_i].to_list()
#             # print("go",user)#++ptint importan
#         else:
#             user = sim_user.iloc[user_id][:sum_i].to_list()
#             status = 1