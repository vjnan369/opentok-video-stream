class InvitationsController < ApplicationController
	def new
		#@invitation = Invitation.new(name: "hello",user_id: 2,email: "hai@hai.com",session_id: "sdfddsf",token: "sdfsew")

	end
	def index
	end

	def create
		@invite_to = User.find_by(id: params[:invitation][:to_user_id])
		params[:invitation][:user_id]=current_user.id
		@inuser=params[:invitation][:inuser]
		params[:invitation][:invited_by]=current_user.name
		params[:invitation][:invited_mail]=current_user.email
		session=@opentok.create_session :media_mode=>:routed
		params[:invitation][:session_id]=session.session_id
		params[:invitation][:token]=@opentok.generate_token session.session_id
		#@invitation = current_user.invitations.create(invitation_params)
		#@usering = users(:jnan)
	#	@invitation=nil
		#people = {:invited_by=>params[:invitation][:invited_by],:invited_mail=>params[:invitation][:invited_mail],:session_id=>params[:invitation][:session_id],:token=>params[:invitation][:token]}
			@invite_to_id = @invite_to.id
			@test_id =1
		if @invite_to.invitations.where(:invited_mail =>current_user.email).present?
			#@invite_to.invitations.find_by(:invited_mail =>current_user.email).destroy
			#@test_id = -99
			@invite_to.invitations.find_by(:invited_mail =>current_user.email).destroy
			@invitation = @invite_to.invitations.build(:invited_by=>params[:invitation][:invited_by],:invited_mail=>params[:invitation][:invited_mail],:session_id=>params[:invitation][:session_id],:token=>params[:invitation][:token])
		else
			#@test_id = 100
			@invitation = @invite_to.invitations.build(:invited_by=>params[:invitation][:invited_by],:invited_mail=>params[:invitation][:invited_mail],:session_id=>params[:invitation][:session_id],:token=>params[:invitation][:token])
		end
		if @invitation.save
			@sessionId = params[:invitation][:session_id]
  		@opentok_token = @opentok.generate_token @sessionId
			#@opentok_token = @opentok.generate_token current_user.session_id
  		#@sessionId = current_user.session_id
			#flash[:success]="invitation sent successfully"
			render 'sessions/room'
		end
	end
	def destroysession
		#flash[:success]="#{params[:session_id]}"
		#@session_id=User.includes(:Invitation).where("session_id=?",params[:session_id])
		#@session_id = params[:invite_to_mail]
		@invite_to = User.find_by(:id => params[:invite_to_id])
		@edit_invitation = @invite_to.invitations.find_by(:invited_mail =>current_user.email).destroy
		if @edit_invitation.save
			redirect_to users_url
		end
		
	end

	private
		def invitation_params
			params.require(:invitation).permit(:invited_by,:invited_mail,:session_id,:token)
		end
end
