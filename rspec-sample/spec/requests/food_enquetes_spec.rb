require 'rails_helper'

RSpec.describe "FoodEnquetes", type: :request do
  describe "正常" do
    context "アンケートに回答する" do
      it "回答できること" do
        # [Point.3-15-1]アンケートページにアクセスします。
        get "/food_enquetes/new"
        # [Point.3-15-2]正常に応答することを確認します。
        expect(response).to have_http_status(200)
          #存在しないHTTPステータスは(404)

        # [Point.3-15-3]正常な入力値を送信します。
        post "/food_enquetes" ,params: { food_enquete: FactoryBot.attributes_for(:food_enquete_tanaka) }
        
        # [Point.3-15-4]リダイレクト先に移動します。
        follow_redirect!

        # [Point.3-15-5]送信完了のメッセージが含まれることを検証します。
        # [文言修正に伴う変更] expect(response.body).to include "お食事に関するアンケートを送信しました"
        expect(response.body).to include "ご回答ありがとうございました"
      end
    end
  end

  describe '異常' do
    context "アンケートに回答する" do
      it "エラーメッセージが表示されること" do
        get "/food_enquetes/new"
        expect(response).to have_http_status(200)

        # [Point.3-15-6]異常な入力値を送信します。
        post "/food_enquetes", params: { food_enquete: {name: ''} }
          #名前が未入力で、その他の入力値は全く未指定である異常な入力値を送信します。
        
        # [Point.3-15-7]送信完了のメッセージが含まれないことを検証します。
        # [文言変更に伴う修正] expect(response.body).not_to include "お食事に関するアンケートを送信しました"
          expect(response.body).not_to include "ご回答ありがとうございました" 
        #リダクレクト先をみる必要はないのでfollow_redirect!を実行しない。
      end
    end
  end
end
