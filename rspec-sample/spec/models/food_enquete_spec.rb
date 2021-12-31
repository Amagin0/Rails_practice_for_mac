require 'rails_helper'

RSpec.describe FoodEnquete, type: :model do

  describe '正常系の機能' do
    #大分類のようなイメージ。何についてテストするかを記述。

    context '回答する' do
      #中分類のようなイメージ。状況を記述する。分類が少ないときは省略が可能。

      it '正しく登録できること 料理:やきそば food_id: 2, 
                            満足度:良い score: 3, 
                            希望するプレゼント:ビール飲み放題 present_id: 1)' do
        #ここのテストケースを表し、期待する振る舞いを記述。

        # [Point.3-3-1]テストデータをfactoriesから呼び出す。
        enquete = FactoryBot.build(:food_enquete_tanaka)
          #build()メソッドはインスタンスをメモリ上のみ記憶する
          #DBに書き込むのは時間がかかるので、保存する必要のない時はbuildを使う
          #属性チェックだけの場合もbuildで良い

        # [Point.3-3-2]「バリデーションが正常に通ること(バリデーションエラーが無いこと)」を検証します。
        expect(enquete).to be_valid
          #expect テストしたいものを指定する。
          #to 「〜であること」を意味する。not_toだと、「〜でないこと」になる。
          #be_valid テストデータのバリデーションが通ること(エラーがないこと)を意味する
          #その他にも、eq「◯◯と同じ」、include「◯◯を含む」などがあり、検証の種類をマッチャーと呼ぶ。

        # [Point.3-3-3]テストデータを保存します。
        enquete.save

        # [Point.3-3-4][Point.3-3-3]で保存したデータを取得します。
        answered_enquete = FoodEnquete.find(1);
        #Rspecの仕様上、テストコード終了後は元の状態位戻るので、データは必ず１件目のデータになる。

        # [Point.3-3-5][Point.3-3-1]で作成したデータを同一か検証します。
        expect(answered_enquete.name).to eq('田中 太郎')
        expect(answered_enquete.mail).to eq('taro.tanaka@example.com')
        expect(answered_enquete.age).to eq(25)
        expect(answered_enquete.food_id).to eq(2)
        expect(answered_enquete.score).to eq(3)
        expect(answered_enquete.request).to eq('おいしかったです。')
        expect(answered_enquete.present_id).to eq(1)

        #bundle exec rspec spec/models/food_enquete_spec.rbを実行して、
        #「.」が出ると成功「F」が出ると失敗。テストコードが想定通りに動作したかわかる。
      end
    end
  end

  describe '入力項目の有無' do
    # [Point.3-11-2]インスタンスを共通化してテストデータを作成します。
    let(:new_enquete) { FoodEnquete.new }
      #FppdEnquente.newをnew_enquenteと定義して共通化している。

    context '必須入力であること' do
      # [Point.3-4-1]itを複数書くことができます。
      it 'お名前が必須であること' do
        # new_enquete = FoodEnquete.new...let(:new_enquente)で共通化

        # [Point.3-4-2]バリデーションエラーが発生することを検証します。
        expect(new_enquete).not_to be_valid
        # [Point.3-4-3]必須入力のメッセージが含まれることを検証します。
        expect(new_enquete.errors[:name]).to include(I18n.t('errors.messages.blank'))
      end

      it 'メールアドレスが必須であること' do
        # new_enquete = FoodEnquete.new...共通化

        expect(new_enquete).not_to be_valid
        expect(new_enquete.errors[:mail]).to include(I18n.t('errors.messages.blank'))
      end

      # [Point.3-4-1]itを複数書くことができます。
      it '登録できないこと' do
        # new_enquete = FoodEnquete.new...共通化

        # [Point.3-4-4]保存に失敗することを検証します。
        expect(new_enquete.save).to be_falsey
          #真偽値(true/false)を検証するとき、be_truthy/be_falseyをマッチャーとする。
      end
    end

    context '任意入力であること' do
      it 'ご意見・ご要望が任意であること' do
        # new_enquete = FoodEnquete.new...共通化

        expect(new_enquete).not_to be_valid
        # [Point.3-4-6]必須入力のメッセージが含まれないことを検証します。
        expect(new_enquete.errors[:request]).not_to include(I18n.t('errors.messages.blank'))
          #エラーメッセージが出ないかどうか検証している→任意入力(ブランクでもok)ということがわかる
      end
    end
  end

  describe 'メールアドレスの形式' do
    context '不正な形式のメールアドレスの場合' do
      it 'エラーになること' do
        new_enquete = FoodEnquete.new
        # [Point.3-7-1]不正な形式のメールアドレスを入力します。
        new_enquete.mail = "taro.tanaka"
        expect(new_enquete).not_to be_valid
        # [Point.3-7-2]不正な形式のメッセージが含まれることを検証します。
        expect(new_enquete.errors[:mail]).to include(I18n.t('errors.messages.invalid'))
      end
    end
  end

  describe 'アンケート回答時の条件' do
    context 'メールアドレスを確認すること' do
      before do
        # [Point.3-6-1]1つ目のテストデータを呼び出す
        FactoryBot.create(:food_enquete_tanaka)
          #create()メソッドはテストデータベース上にも保存して、データを永続化させる。
      end

      it '同じメールアドレスで再び回答出来ない事' do

        # [Point.3-6-2]2つ目のテストデータを作成します。
        re_enquete_tanaka = FactoryBot.build(:food_enquete_tanaka, food_id: 0, score: 1, present_id: 0, request: "スープがぬるかった")
          #FactoryBot.build(クラス名, 上書きしたい項目: XX)を呼出すと、上書きできる。

        expect(re_enquete_tanaka).not_to be_valid

        # [Point.3-6-3]メールアドレスが既に存在するメッセージが含まれることを検証します。
        expect(re_enquete_tanaka.errors[:mail]).to include(I18n.t('errors.messages.taken'))
        expect(re_enquete_tanaka.save).to be_falsey
        expect(FoodEnquete.all.size).to eq 1
      end

      it '異なるメールアドレスで回答できること' do
        #FactoryBot.create(:food_enquete_tanaka)...before actionに追加
        #田中を呼び出している
        enquete_yamada = FactoryBot.build(:food_enquete_yamada) #山田を呼び出している

        expect(enquete_yamada).to be_valid
        enquete_yamada.save
        # [Point.3-6-4]問題なく登録できます。
        expect(FoodEnquete.all.size).to eq 2
      end
    end

    context '年齢を確認すること' do
      it '未成年はビール飲み放題を選択できないこと' do
        # [Point.3-5-3]未成年のテストデータをfactoriesから呼び出している
        enquete_sato = FactoryBot.build(:food_enquete_sato) #佐藤を呼び出している
  
        expect(enquete_sato).not_to be_valid
        # [Point.3-5-4]成人のみ選択できる旨のメッセージが含まれることを検証します。
        expect(enquete_sato.errors[:present_id]).to include(I18n.t('activerecord.errors.models.food_enquete.attributes.present_id.cannot_present_to_minor'))
      end

      it '成人はビール飲み放題を選択できないこと' do
        # [Point.3-5-5]成人のテストデータを作成します。
        enquete_sato = FactoryBot.build(:food_enquete_sato, age: 20)
  
        # [Point.3-5-6]「バリデーションが正常に通ること(バリデーションエラーが無いこと)」を検証します。
        expect(enquete_sato).to be_valid
      end
    end
  end

  describe '#adult?' do
    it '20歳未満は成人ではないこと' do
      foodEnquete = FoodEnquete.new
      # [Point.3-5-1]未成年になることを検証します。
      expect(foodEnquete.send(:adult?, 19)).to be_falsey
    end
    
    it '20歳以上は成人であること' do
      foodEnquete = FoodEnquete.new
      # [Point.3-5-2]成人になることを検証します。
      expect(foodEnquete.send(:adult?, 20)).to be_truthy
    end
      #モデルのプライベートメソッドはインスタンスから直接呼び出すことができない。
      #sendメソッドに検証したいプライベートメソッドを指定する。
  end

  describe '共通メソッド' do
  # [Point.3-12-3]共通化するテストケースを定義します。
    it_behaves_like '価格の表示'
    it_behaves_like '満足度の表示'
  end
end
