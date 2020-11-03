class ArticlesController < ApplicationController

    before_action :set_article, only: [:show, :edit, :update, :destroy]
    before_action :require_user, except: [:show, :index]
    before_action :require_same_user, only: [:edit, :update, :destroy]
    def show
        
    end
    def index
        
        @articles = Article.paginate(page: params[:page], per_page: 5)
        if params[:search]
            @search_term = params[:search]
            @articles = @articles.search_by(@search_term)
            
        end
        if params[:order]=== "1"
             @articles = @articles.order(created_at: :desc)
            else 
                @articles = @articles.order(created_at: :ASC)

        end
      
    end
    def new
        @article = Article.new
    end
    def edit
        
    end
    def create 
   
        @article = Article.new(params.require(:article).permit(:title, :description))
     
        @article.user = current_user

        if @article.save
            redirect_to article_path(@article), success: "Article was created successfully."
        else
            render 'new'
        end
    end

    def update
        if @article.update(params.require(:article).permit(:title, :description))
            redirect_to article_path(@article), success: "Article was updated successfully."
        else
            render 'edit'
        end
    end
    def destroy
        @article.destroy
        redirect_to articles_path

    end
    private

    def set_article
        @article = Article.find(params[:id])
    end

    def require_same_user
        if current_user != @article.user && !current_user.admin?
            redirect_to @article, danger: "You can only update and/or delete your own articles"
        end
    end

end
