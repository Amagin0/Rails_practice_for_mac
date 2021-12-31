require 'rails_helper'

shared_examples '入力項目の有無' do
  let(:object_name) { described_class.to_s.underscore.to_sym }
  let(:model) { FactoryBot.build(object_name) }

  context '必須入力であること' do
    it 'お名前が必須であること' do
      expect(model).not_to be_valid
      expect(model.errors[:name]).to include(I18n.t('errors.messages.blank'))
    end

    it 'メールアドレスが必須であること' do
      expect(model).not_to be_valid
      expect(model.errors[:mail]).to include(I18n.t('errors.messages.blank'))
    end

    it '登録できないこと' do
      expect(model.save).to be_falsey
    end
  end

  context '任意入力であること' do
    it 'ご意見・ご要望が任意であること' do
      expect(model).not_to be_valid
      expect(model.errors[:request]).not_to include(I18n.t('errors.messages.blank'))
    end
  end
end

shared_examples 'メールアドレスの形式' do
  let(:object_name) { described_class.to_s.underscore.to_sym }
  let(:model) { FactoryBot.build(object_name) }

  context '不正な形式のメールアドレスの場合' do
    it 'エラーになること' do
      model.mail = "taro.tanaka"
      expect(model).not_to be_valid
      expect(model.errors[:mail]).to include(I18n.t('errors.messages.invalid'))
    end
  end
end

# [Point.3-12-1]共通化するテストケースを定義します。
shared_examples '価格の表示' do
  #shared_examples...テストコードの定義
  #it_behaves_like...テストコードを呼び出す(model側で記載)

  # [Point.3-12-2]呼出し元のモデルを動的に定義します。
  let(:object_name) { described_class.to_s.underscore.to_sym }
  let(:model) { FactoryBot.build(object_name) }
    #共通化のテストコードは各モデルから呼び出されるので、
    #FactoryBot.build(:food_enquete)なのか、FactoryBot.build(:gym_enquete)なのか
    #わからないため、予めソースコードを書くことが出来ない。
    #described_class.to_s.underscore.to_symで判定をし、シンボルを自動で取得して
    #そのシンボルを元にFactoryBot.buildを実行する。
    #自動的に各々のモデルを作成することを「動的」という。

  describe '税込み価格が計算されること' do
#----------------消費税変更による修正--------------
    # it '8%加算されること' do
    #   expect(model.tax_included_price(100)).to eq 108
    # end

    # it '8%加算され、小数点以下が切り捨てられること' do
    #   expect(model.tax_included_price(101)).to eq 109
    # end
#----------------消費税変更による修正 終わり--------------

it '10%加算されること' do
  expect(model.tax_included_price(100)).to eq 110
end

it '10%加算され、小数点以下が切り捨てられること' do
  expect(model.tax_included_price(101)).to eq 111
end


  end
end

shared_examples '満足度の表示' do
  let(:object_name) { described_class.to_s.underscore.to_sym }
  let(:model) { FactoryBot.build(object_name) }

  it '満足度が「悪い」になること' do
    model.score = 1
    expect(model.view_score).to eq I18n.t('common.score.bad')
  end

  it '満足度が「普通」になること' do
    model.score = 2
    expect(model.view_score).to eq I18n.t('common.score.normal')
  end

  it '満足度が「良い」になること' do
    model.score = 3
    expect(model.view_score).to eq I18n.t('common.score.good')
  end

  it '満足度が「不明」になること' do
    model.score = 0
    expect(model.view_score).to eq I18n.t('common.score.unknown')

    model.score = 4
    expect(model.view_score).to eq I18n.t('common.score.unknown')
  end
end
