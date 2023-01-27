class MemberContest < ApplicationRecord
  belongs_to :school

  enum list_contest: [ 'Pertolongan Pertama', 'Perawatan Keluarga' ]
end
