//策略說明:<br/>
//假設三根bar就可以構成一個橋接和兩個箱型<br/>
//透過偏移第一根bar來跟第三根bar比對，如果相互沒有重疊，即視為兩個箱型，而中間第二根視為橋接<br/>
//在上述基礎之下，在第四根bar開盤進場(讓第三根描寫完，用以確定第2根bar是橋接)<br/>
//停損在第一根bar的高點(視第一根bar的高點為前一個箱型的頂)<br/>
//停利在第三根bar的高點(視第三根bar的低點為現在箱型的頂)<br/>
//<br/>
//<br/>
//參數:<br/>
//MA1 最高價 向後偏移2 <br/>
//MA1 最低價 向後偏移2 <br/>





## Tips
程式歸宿:<br/>
classpack.mqh >>> Include 第一層<br/>
策略程式 >>>Exprets 第一層<br/>



如果查資料時https://www.mql5.com被封掉，到C:\Windows\System32\drivers\etc，去找到hosts把127.0.0.1 www.mql5.com刪掉。<br/>
