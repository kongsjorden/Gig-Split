import SwiftUI

struct TipsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text(Strings.Tips.gettingStarted)) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(Strings.Tips.addBandTip)
                            .font(.body)
                        Text(Strings.Tips.addMembersTip)
                            .font(.body)
                        Text(Strings.Tips.setMileageRateTip)
                            .font(.body)
                    }
                }
                
                Section(header: Text(Strings.Tips.addingGigs)) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(Strings.Tips.addGigTip)
                            .font(.body)
                        Text(Strings.Tips.addExpensesTip)
                            .font(.body)
                        Text(Strings.Tips.addDrivingTip)
                            .font(.body)
                    }
                }
                
                Section(header: Text(Strings.Tips.managingExpenses)) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(Strings.Tips.receiptsTip)
                            .font(.body)
                        Text(Strings.Tips.editExpensesTip)
                            .font(.body)
                    }
                }
            }
            .navigationTitle(Strings.Tips.tips)
            .navigationBarItems(
                trailing: Button(Strings.General.done) {
                    dismiss()
                }
            )
        }
    }
}