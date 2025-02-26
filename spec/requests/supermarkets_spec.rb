# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Supermarkets", type: :request do
  let(:valid_attrs) { { supermarket: attributes_for(:supermarket) }.as_json }
  let(:invalid_attrs) { { supermarket: attributes_for(:supermarket, name: nil) }.as_json }
  let(:user) { create(:user) }

  describe "/v1/supermarkets" do
    context "GET" do
      before { create_list(:supermarket, 3) }

      context "when logged in" do
        before(:each) { get v1_supermarkets_path, headers: authenticated_header(user) }

        it "should be returns success" do
          expect(response).to have_http_status(200)
        end

        it "validate serializer" do
          expect(response).to match_response_schema("supermarkets")
        end

        it "should be returns a supermarket list" do
          expect(response.body).not_to be_blank
          expect(json).not_to be_empty
          expect(json["data"].count).to be >= 3
        end
      end

      context "when logged out" do
        before(:each) { get v1_supermarkets_path }

        it_behaves_like "a unauthorized error"
      end
    end

    context "POST" do
      context "valid supermarket attributes" do
        before(:each) { post v1_supermarkets_path, params: valid_attrs, headers: authenticated_header(user) }

        it "should return a created supermarket" do
          expect(response).to have_http_status(200)
        end

        it "validate serializer" do
          expect(response).to match_response_schema("supermarket")
        end

        it_behaves_like "a json pattern" do
          let(:body) { json }
          let(:attrs) { valid_attrs }
        end

        it_behaves_like "a supermarket attributes" do
          let(:body) { json }
          let(:attrs) { valid_attrs }
        end
      end

      context "invalid supermarket attributes" do
        before(:each) { post v1_supermarkets_path, params: invalid_attrs, headers: authenticated_header(user) }

        it_behaves_like "a unprocessable error", :supermarkets
      end

      context "when logged out" do
        before(:each) { post v1_supermarkets_path, params: valid_attrs }

        it_behaves_like "a unauthorized error"
      end
    end
  end

  describe "/v1/supermarkets/:id" do
    let(:supermarket) { create(:supermarket) }

    context "GET" do
      context "when logged in" do
        context "valid supermarket attributes" do
          before(:each) { get v1_supermarket_path(supermarket.id), headers: authenticated_header(user) }

          it "should be returns success" do
            expect(response.content_type).to eq("application/json")
            expect(response).to have_http_status(200)
          end

          it "validate supermarket serializer" do
            expect(response).to match_response_schema("supermarket")
          end

          it "should be returns a supermarket" do
            expect(response.body).not_to be_blank
            expect(json["data"]).not_to be_empty
          end

          it_behaves_like "a json pattern" do
            let(:body) { json }
            let(:attrs) { valid_attrs }
          end

          it_behaves_like "a supermarket attributes" do
            let(:body) { json }
            let(:attrs) { valid_attrs }
          end
        end
        context "invalid supermarket attributes" do
          before(:each) { get v1_supermarket_path(0), headers: authenticated_header(user) }

          it_behaves_like "a not found error", :supermarket, 0
        end

        context "when logged out" do
          before(:each) { get v1_supermarket_path(supermarket.id) }

          it_behaves_like "a unauthorized error"
        end
      end
    end
    context "PUT" do
      let(:new_valid_attrs) { valid_attrs }

      context "when logged in" do
        context "valid supermarket attributes" do
          before(:each) { put v1_supermarket_path(supermarket.id), params: new_valid_attrs, headers: authenticated_header(user) }

          it "should be returns success" do
            expect(response.content_type).to eq("application/json")
            expect(response).to have_http_status(200)
          end

          it "validate supermarket serializer" do
            expect(response).to match_response_schema("supermarket")
          end

          it_behaves_like "a json pattern" do
            let(:body) { json }
            let(:attrs) { new_valid_attrs }
          end

          it_behaves_like "a supermarket attributes" do
            let(:body) { json }
            let(:attrs) { new_valid_attrs }
          end
        end

        context "with invalid supermarket attributes" do
          describe "invalid id" do
            before(:each) { put v1_supermarket_path(0), params: new_valid_attrs, headers: authenticated_header(user) }

            it_behaves_like "a not found error", :supermarket, 0
          end

          describe "invalid params" do
            before(:each) { put v1_supermarket_path(supermarket.id), params: invalid_attrs, headers: authenticated_header(user) }

            it_behaves_like "a unprocessable error", :supermarket
          end
        end
      end

      context "when logged out" do
        before(:each) { put v1_supermarket_path(supermarket.id), params: new_valid_attrs }

        it_behaves_like "a unauthorized error"
      end
    end

    context "PATCH" do
      let(:new_valid_attrs) { valid_attrs }

      context "when logged in" do
        context "valid supermarket attributes" do
          before(:each) { patch v1_supermarket_path(supermarket.id), params: new_valid_attrs, headers: authenticated_header(user) }

          it "should be returns success" do
            expect(response.content_type).to eq("application/json")
            expect(response).to have_http_status(200)
          end

          it "validate supermarket serializer" do
            expect(response).to match_response_schema("supermarket")
          end

          it_behaves_like "a json pattern" do
           let(:body) { json }
           let(:attrs) { new_valid_attrs }
         end

          it_behaves_like "a supermarket attributes" do
            let(:body) { json }
            let(:attrs) { new_valid_attrs }
          end
        end

        context "with invalid supermarket attributes" do
          describe "invalid id" do
            before(:each) { patch v1_supermarket_path(0), params: new_valid_attrs, headers: authenticated_header(user) }

            it_behaves_like "a not found error", :supermarket, 0
          end

          describe "invalid params" do
            before(:each) { patch v1_supermarket_path(supermarket.id), params: invalid_attrs, headers: authenticated_header(user) }

            it_behaves_like "a unprocessable error", :supermarket
          end
        end
      end

      context "when logged out" do
        before(:each) { patch v1_supermarket_path(supermarket.id), params: new_valid_attrs }

        it_behaves_like "a unauthorized error"
      end
    end

    context "DELETE" do
      context "when logged in" do
        context "valid supermarket attributes" do
          before(:each) { delete v1_supermarket_path(supermarket.id), headers: authenticated_header(user) }

          it "should destroy a supermarket" do
            expect(response.body).to be_empty
            expect(response).to have_http_status(204)
          end
        end

        context "invalid supermarket attributes_" do
          before(:each) { delete v1_supermarket_path(0), headers: authenticated_header(user) }

          it_behaves_like "a not found error", :supermarket, 0
        end
      end

      context "when logged out" do
        before(:each) { delete v1_supermarket_path(supermarket.id) }

        it_behaves_like "a unauthorized error"
      end
    end

  end
end
