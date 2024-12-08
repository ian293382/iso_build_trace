# python_demo

1. 這裡只是做一個簡單的python fast專安
2. `sudo apt install python3-venv` 安裝虛擬環境套件 
    - `source env/bin/activate` 啟用該專案下的pyton 環境
    - 下 `pip install -r requirements.txt` 
    - 檢查 `ls env/bin` <br>
        - 若只有兩樣檔案 `python` `pyton3` 代表先前的安裝失敗 請 `rm -rf env`
        - 再執行一次` python3 -m venv env` 
3. 
    - `sudo apt update`
    - `sudo apt install mysql-server`
    - ### 創建 Mysql帳戶
        - sudo mysql;
        變更密碼
          - ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'jms112';<br>
          更新權限
          - FLUSH PRIVILEGES;
    ....... 經過多次使用把FastApi 和 Mysql連接 python 建議裝3.9以上
    




# ref
1. https://www.youtube.com/watch?v=zzOwU41UjTM&ab_channel=EricRoby 