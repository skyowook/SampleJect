from google_play_scraper import app 

result = app(
    'com.koreainvestment.android.keybank',
    lang='ko',
    country='kr'
)
print(result)