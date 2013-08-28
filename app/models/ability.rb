class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action
    # on. If you pass :all it will apply to every resource. Otherwise pass a
    # Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter
    # the objects.  For example, here the user can only update published
    # articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
    user ||= User.new

    if user.dm?
      can :manage, :all
    else
      # https://github.com/ryanb/cancan/issues/213
      ugly_sql = <<EOF
subjects.id IN (
  SELECT subject_id
    FROM veil_passes
    WHERE veil_passes.user_id = ?)
EOF
      can :read, Subject, [ugly_sql, user.id] do |subject|
        subject.veil_passes.map(&:user_id).include?(user.id)
      end
      can :read, Subject, :dm_only => false


      # https://github.com/ryanb/cancan/issues/213
      ugly_sql = <<EOF
veil_passes.id IN (
  SELECT veil_passes.id
    FROM veil_passes
    LEFT JOIN veil_passes vp ON veil_passes.subject_id = vp.subject_id
    WHERE veil_passes.user_id = ? AND vp.user_id <> ?)
EOF
      can :read, VeilPass, [ugly_sql, user.id, user.id] do |vp|
        true
      end

      can :read, VeilPass, :user_id => user.id


      # https://github.com/ryanb/cancan/issues/213
      ugly_sql = <<EOF
attachments.id IN (
  SELECT attachments.id
    FROM attachments
    LEFT JOIN veil_passes ON veil_passes.subject_id = attachments.subject_id
    WHERE veil_passes.user_id = ? AND
      veil_passes.includes_attachments IS true)
EOF
      can :read, Attachment, [ugly_sql, user.id]
      can :read, Attachment, :dm_only => false

      if user.persisted?
        can :create, Comment
        can :manage, Comment, user_id: user.id
      end
      can :read, Comment
    end
  end

end
