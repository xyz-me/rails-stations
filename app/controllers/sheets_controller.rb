class SheetsController < ApplicationController
  def index
    @sheets = Sheet.all

    # 配列に変換
    @sheets_array = [] # 最終結果
    $tmp_array = [] # 一時保存
    
    @sheets.each_with_index do |sheet, i|
      if i > 0 && @sheets[i - 1]["row"] != @sheets[i]["row"]
        # rowが変わるタイミングで$tmp_arrayをsheets_arrayに挿入
        @sheets_array.push($tmp_array)
        $tmp_array = []
      end
      $tmp_array.push(@sheets[i])
    end

    if $tmp_array.length != 0
      @sheets_array.push($tmp_array)
    end
  end
end
