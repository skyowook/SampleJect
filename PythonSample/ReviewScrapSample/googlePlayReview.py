from google_play_scraper import Sort, reviews, reviews_all
import pandas as pd 

# result, continuation_token = reviews(
#     'com.koreainvestment.android.keybank',
#     lang='ko',
#     country='kr',
#     sort=Sort.NEWEST,
#     count=3,
#     filter_score_with=5
# )

# result, _ = reviews(
#     'com.koreainvestment.android.keybank',
#     continuation_token=continuation_token
# )

result = reviews_all(
    'com.koreainvestment.android.keybank',
    sleep_milliseconds=0,
    lang='ko',
    country='kr'
)

test = pd.DataFrame(result)
writer = pd.ExcelWriter(r"/Users/skw/Desktop/Development/SampleJect/PythonSample/ReviewScrapSample/test.xlsx", engine='xlsxwriter')
# print(test)
test.to_excel(writer, sheet_name='Android')
writer.close()