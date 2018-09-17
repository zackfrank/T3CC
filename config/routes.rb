Rails.application.routes.draw do
  namespace :v1 do
    get "/games" => "games#index"
    post "/games" => "games#create"
    get "/games/:id" => "games#show"
    patch "/games/:id" => "games#update"
    delete "/games/:id" => "games#destroy"

    get "/boards" => "boards#index"
    post "/boards" => "boards#create"
    get "/boards/:id" => "boards#show"
    patch "/boards/:id" => "boards#update"
    delete "/boards/:id" => "boards#destroy"

    get "/humen" => "humen#index"
    post "/humen" => "humen#create"
    get "/humen/:id" => "humen#show"
    patch "/humen/:id" => "humen#update"
    delete "/humen/:id" => "humen#destroy"

    get "/computers" => "computers#index"
    post "/computers" => "computers#create"
    get "/computers/:id" => "computers#show"
    patch "/computers/:id" => "computers#update"
    delete "/computers/:id" => "computers#destroy"
  end
end
