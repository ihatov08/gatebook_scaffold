class NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [ :edit, :update]
  before_action :set_note, only: [:show, :edit, :update, :destroy, :liking_users]


  def create
    @note = current_user.notes.build(note_params)
    if @note.save
    redirect_to @note, notice: "投稿が保存されました"
  else
    @notes = Note.all.order(created_at: :desc)
    render 'home/top'
  end
  end

  def show

  end

  def edit
  end

  def update
    if @note.update(note_params)
      redirect_to @note, notice: '投稿が更新されました'
    else
      render :edit
    end
  end

  def destroy
    @note.destroy
    redirect_to root_path
  end

  def liking_users
    @users = @note.liking_users
  end

      def like
    note = Note.find(params[:note_id])
    # 変数likeに、current_userとbuildを用いてLikeインスタンスを代入してください
    like = current_user.likes.build(note_id: note.id)
    # saveメソッドで、likeを保存してください
    like.save
    redirect_to note
  end

  def unlike
    note = Note.find(params[:note_id])
    # 変数likeに、current_userとfind_byを用いてLikeインスタンスを代入してください
    like = current_user.likes.find_by(note_id: note.id)
    # destroyメソッドで、likeを削除してください
    like.destroy
    redirect_to note
  end
#返信機能
  def reply
    note = current_user.notes.build(note_params)
    if note.save
      redirect_to root_url
    else
      render :show
    end
  end

  private
   def set_note
    @note = Note.find(params[:id])
   end

   def note_params
    params.require(:note).permit(:title, :content, :reply_note_id)
   end

   def correct_user
      note = Note.find(params[:id])
      # noteを投稿したユーザーを取得し、current_user?メソッドの引数に渡してください
      if !current_user?(note.user)
        redirect_to root_path, alert: '許可されていないページです'
      end
    end


end
