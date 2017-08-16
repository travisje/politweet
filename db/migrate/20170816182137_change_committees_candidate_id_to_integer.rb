class ChangeCommitteesCandidateIdToInteger < ActiveRecord::Migration[5.1]
    def up
      execute %q{
        alter table committees
        alter column candidate_id
        type int using cast(candidate_id as int)
      }
    end
end
