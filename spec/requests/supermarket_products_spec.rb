# frozen_string_literal: true

require "rails_helper"

RSpec.describe "SupermarketProducts", type: :request do
  let(:supermarket) { create(:supermarket) }
  let(:valid_attrs) { { supermarket_product: attributes_for(:supermarket_product, :with_price).as_json } }
  let(:invalid_attrs) { { supermarket_product: attributes_for(:supermarket_product, product_id: nil).as_json } }
  let(:user) { create(:user) }

  describe "/v1/supermarket/:supermarket_id/products" do
    context "GET" do
      before { create(:supermarket_product, :with_supermarket, supermarket_id: supermarket.id) }
      context "when logged in" do
        before(:each) { get v1_supermarket_products_path(supermarket.id), headers: authenticated_header(user) }

        it "should be returns a success" do
          expect(response).to have_http_status(200)
        end

        it "validate serializer" do
          expect(response).to match_response_schema("supermarket_products")
        end

        it "should be returns a products list from supermarket" do
          expect(response.body).not_to be_blank
          expect(json).not_to be_empty
          expect(json["data"].count).to be >= 1
        end
      end

      context "when logged out" do
        before(:each) { get v1_supermarket_products_path(supermarket.id) }

        it_behaves_like "a unauthorized error"
      end
    end

    context "POST" do
      context "valid supermarket product attributes" do
        before(:each) { post v1_supermarket_products_path(supermarket.id), params: valid_attrs, headers: authenticated_header(user) }

        it "should return a created supermarket product" do
          expect(response).to have_http_status(200)
        end

        it "validate serializer" do
          expect(response).to match_response_schema("supermarket_product")
        end

        it_behaves_like "a json with relationship pattern" do
          let(:body) { json }
          let(:attrs) { valid_attrs }
        end

        it_behaves_like "a supermarket product attributes" do
          let(:body) { json }
          let(:attrs) { valid_attrs }
        end
      end

      context "invalid product attributes" do
        before(:each) { post v1_supermarket_products_path(supermarket.id), params: invalid_attrs, headers: authenticated_header(user) }

        it_behaves_like "a unprocessable error", :supermarketProduct
      end

      context "when logged out" do
        before(:each) { post v1_supermarket_products_path(supermarket.id), params: valid_attrs }

        it_behaves_like "a unauthorized error"
      end
    end

    context "create product and add to supermarket" do
      context "valid attributes" do
        let(:product_supermarket_product) { 
          { 
            product: attributes_for(:product).as_json,  
            supermarket_product: attributes_for(:supermarket_product, :with_price).as_json
          } 
        }

        before(:each) { post v1_supermarket_create_and_add_path(supermarket.id), params: product_supermarket_product, headers: authenticated_header(user) }

        it "should return a created product and added to supermarket" do
          expect(response).to have_http_status(200)
        end

        it "validate serializer" do
          expect(response).to match_response_schema("supermarket_product")
        end

        it_behaves_like "a json pattern" do
          let(:body) { json }
          let(:attrs) { product_supermarket_product }
        end

        it_behaves_like "a supermarket product attributes" do
          let(:body) { json }
          let(:attrs) { product_supermarket_product }
        end
      end

      context "invalid attributes" do
        let(:invalid_product) {
            {
              product: attributes_for(:product, barcode: nil).as_json,  
              supermarket_product: attributes_for(:supermarket_product, :with_price, product_id: 0).as_json
            } 
        }

        let(:invalid_product_supermarket_product) { 
          { 
            product: attributes_for(:product).as_json,  
            supermarket_product: attributes_for(:supermarket_product, :with_price, product_id: 0).as_json
          } 
        }

        context "invalid supermarket product attributes" do
          before(:each) { post v1_supermarket_create_and_add_path(supermarket.id), params: invalid_product_supermarket_product, headers: authenticated_header(user) }

          it_behaves_like "a unprocessable error", :supermarketProduct
        end

        context "invalid product attributes" do
          before(:each) { post v1_supermarket_create_and_add_path(supermarket.id), params: invalid_product, headers: authenticated_header(user) }

          it_behaves_like "a unprocessable error", :supermarketProduct
        end
      end
    end
  end

  describe "/v1/supermarket/:supermarket_id/products/:id" do
    let(:product) { create(:supermarket_product, :with_price, :with_supermarket, supermarket_id: supermarket.id) }

    context "GET" do
      context "when logged in" do
        context "valid product attributes" do
          before(:each) { get v1_supermarket_product_path(supermarket.id, product.id), headers: authenticated_header(user) }

          it "should be returns success" do
            expect(response.content_type).to eq("application/json")
            expect(response).to have_http_status(200)
          end

          it "validate product serializer" do
            expect(response).to match_response_schema("supermarket_product")
          end

          it "should be returns a product" do
            expect(response.body).not_to be_blank
            expect(json["data"]).not_to be_empty
          end

          it_behaves_like "a json pattern" do
            let(:body) { json }
            let(:attrs) { valid_attrs }
          end

          it_behaves_like "a supermarket product attributes" do
            let(:body) { json }
            let(:attrs) { valid_attrs }
          end
        end
        context "invalid product attributes" do
          before(:each) { get v1_supermarket_product_path(supermarket.id, 0), headers: authenticated_header(user) }

          it_behaves_like "a not found error", :supermarketProduct, 0
        end

        context "when logged out" do
          before(:each) { get v1_supermarket_product_path(supermarket.id, product.id) }

          it_behaves_like "a unauthorized error"
        end
      end
    end

    context "DELETE" do
      context "when logged in" do
        context "valid supermarket product attributes" do
          before(:each) { delete v1_supermarket_product_path(supermarket.id, product.id), headers: authenticated_header(user) }

          it "should destroy a supermarket product" do
            expect(response.body).to be_empty
            expect(response).to have_http_status(204)
          end
        end

        context "invalid supermarket product attributes" do
          before(:each) { delete v1_supermarket_product_path(supermarket.id, 0), headers: authenticated_header(user) }

          it_behaves_like "a not found error", :supermarketProduct, 0
        end
      end

      context "when logged out" do
        before(:each) { delete v1_supermarket_product_path(supermarket.id, product.id) }

        it_behaves_like "a unauthorized error"
      end
    end

  end
end
