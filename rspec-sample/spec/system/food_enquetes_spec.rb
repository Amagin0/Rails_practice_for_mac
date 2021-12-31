require 'rails_helper'

RSpec.describe "FoodEnquentes", type: :system do
  describe "正常" do
    context "アンケートに回答する" do
      it "回答できること" do
        # [Point.6-2-2]「田中 太郎」のテストデータを作成します。
        enquete = FactoryBot.create(:food_enquete_tanaka)
        
        # [Point.6-2-3]アンケートページにアクセスします。
        visit "/food_enquetes/new"
        
        # [Point.6-2-4]テキストボックスに値を入力します。
        fill_in 'お名前', with: enquete.name
          #fill_in (テキストボックスのラベル名), with: (値)でテキストボックスの値を入力。

        # [Point.6-2-4]テキストボックスに値を入力します。
        fill_in 'メールアドレス', with: enquete.mail

        # [Point.6-2-4]テキストボックスに値を入力します。
        fill_in '年齢', with: enquete.age

        # [Point.6-2-5]セレクトボックスを選択します。
        select enquete.food_name, from: 'お召し上がりになった料理'
          #select (選択肢), from: (セレクトボックスのラベル名)でセレクトボックスを選択。

        # [Point.6-2-6]ラジオボタンを選択します。
        choose "food_enquete_score_#{enquete.score}"
          #choose (ラジオボックスのラベル名)でラジオボタンを選択できる
          #今回は、HTMLのidを指定してchoose (ラジオボックスのid)でラジオボタンを選択

        # [Point.6-2-4]テキストボックスに値を入力します。
        fill_in 'ご意見・ご要望', with: enquete.request

        # [Point.6-2-5]セレクトボックスを選択します。
        select enquete.present_name, from: 'ご希望のプレゼント'

        # 見た目をわかりやすくするために動作を2秒止めています。
        # 通常は自動テストが遅くなりますので不要な処理です。
        sleep 2

        # [Point.6-2-7]「登録する」ボタンをクリックします。
        click_button '登録する'
          #click (ボタンのsubmit値)でボタンをクリック

        expect(page).to have_content 'ご回答ありがとうございました'
        expect(page).to have_content 'お名前: 田中 太郎'
        expect(page).to have_content 'メールアドレス: taro.tanaka@example.com'
        expect(page).to have_content '年齢: 25'
        expect(page).to have_content 'お召し上がりになった料理: やきそば'
        expect(page).to have_content '満足度: 良い'
        expect(page).to have_content 'ご意見・ご要望: おいしかったです。'
        expect(page).to have_content 'ご希望のプレゼント: 【10名に当たる】ビール飲み放題'
      
        # 見た目をわかりやすくするために動作を2秒止めています。
        # 通常は自動テストが遅くなりますので不要な処理です。
        sleep 3
      end
    end
  end
describe "異常" do
  context "必須項目が未入力" do
    it "エラーメッセージが表示され、回答出来ないこと" do
      visit "/food_enquetes/new"
      sleep 2
      click_button '登録する'
      expect(page).not_to have_content 'ご回答ありがとうございました'
      expect(page).to have_content 'お名前を入力してください'
      expect(page).to have_content 'メールアドレスを入力してください'
      expect(page).to have_content '年齢を入力してください'
      expect(page).to have_content '満足度を入力してください'
      sleep 3
    end
  end
end

end