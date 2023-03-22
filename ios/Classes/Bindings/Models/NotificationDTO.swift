import Foundation
import VoxeetSDK

extension DTO {

    struct Subscription: Codable {
        enum SubsriptionType: String, Codable {
            case invitationReceived = "SUBSCRIPTION_TYPE_INVITATION_RECEIVED"
            case activeParticipants = "SUBSCRIPTION_TYPE_ACTIVE_PARTICIPANTS"
            case conferenceCreated = "SUBSCRIPTION_TYPE_CONFERENCE_CREATED"
            case conferenceEnded = "SUBSCRIPTION_TYPE_CONFERENCE_ENDED"
            case participantJoined = "SUBSCRIPTION_TYPE_PARTICIPANT_JOINED"
            case participantLeft = "SUBSCRIPTION_TYPE_PARTICIPANT_LEFT"
        }

        let type: SubsriptionType
        let conferenceAlias: String

        func toSdkType() -> VTSubscribeBase {
            switch type {
            case .invitationReceived: return VTSubscribeInvitation(conferenceAlias: conferenceAlias)
            case .activeParticipants: return VTSubscribeActiveParticipants(conferenceAlias: conferenceAlias)
            case .conferenceCreated: return VTSubscribeConferenceCreated(conferenceAlias: conferenceAlias)
            case .conferenceEnded: return VTSubscribeConferenceEnded(conferenceAlias: conferenceAlias)
            case .participantJoined: return VTSubscribeParticipantJoined(conferenceAlias: conferenceAlias)
            case .participantLeft: return VTSubscribeParticipantLeft(conferenceAlias: conferenceAlias)
            }
        }
    }

    struct InvitationReceivedNotification: Codable {
        let conferenceId: String
        let conferenceAlias: String
        let participant: Participant

        init(invitationReceivedNotification: VTInvitationReceivedNotification) {
            conferenceId = invitationReceivedNotification.conferenceID
            conferenceAlias = invitationReceivedNotification.conferenceAlias
            participant = Participant(participant: invitationReceivedNotification.participant)
        }
    }
}
