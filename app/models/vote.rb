class Vote < ActiveRecord::Base
  # Read the votes from a separate database, defined in "database.yml":
  establish_connection :votes

  # Associations
  belongs_to :proposal

  # Write a CSV-formatted voting summary for the +event+ to +filename+.
  def self.write_summary_for(event, filename="#{RAILS_ROOT}/votes.csv")
    FasterCSV.open(filename, 'w') do |csv|
        self.summary_for(event).each { |vote| csv << vote }
    end
  end

  # Return array containing the voting summary for the +event+. The data
  # structure's first line is an array of column names, and the remaining rows
  # are data. The "relevance" is how relevant the talk is to the event, and
  # "interestingness" is how interested people are in this talk.
  #
  # Example:
  #   [
  #     ['proposal_id', 'proposal_title', 'speaker_names', 'track_title', 'session_type_title', 'session_type_duration', 'relevance', 'interestingness'],
  #     [1, "Exciting things!", "Bob Smith", "Things Track", "Long Session", 105, 10, 10],
  #     [2, "Boring things!", "Sleepy Smith", "Things Track", "Long Session", 105, -99, -99],
  #     [3, "Kittens!", "OMG", "Critters Track", "Long Session", 105, 19, 32],
  #   ]
  def self.summary_for(event)
    case event
    when Event
      # Ignore, it's already in desired format.
    when String, Symbol
      event = Event.lookup(event)
    else
      raise TypeError, "Unknown event type: #{event.class}"
    end

    returning([]) do |result|
      result << %w[
        proposal_id
        proposal_title
        speaker_names
        track_title
        session_type_title
        session_type_duration
        relevance
        interestingness
      ]
      event.proposals.each do |proposal|
        relevance       = proposal.votes.ergo.map(&:relevance).ergo.sum
        interestingness = proposal.votes.ergo.map(&:interestingness).ergo.sum
        result << [
          proposal.id,
          proposal.title,
          proposal.users.map(&:fullname).join(', '),
          proposal.track.title,
          proposal.session_type.title,
          proposal.session_type.duration,
          relevance,
          interestingness
        ]
      end
    end
  end
end
