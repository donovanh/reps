import SwiftUI
import SwiftData

struct WeekView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var routines: [Routine]
    @State private var isPresentingAddExercise: Bool = false
    @State private var showingPlanBuilder = false
    
    let weekDays = [2,3,4,5,6,7,1] // TODO: Internationalise to Sunday first
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Button {
                        showingPlanBuilder.toggle()
                    } label: {
                        Text("Build new plan")
                    }
                    Spacer()
                    EditButton()
                }
                .padding()
                List {
                    ForEach(weekDays, id: \.self) { day in
                        DayView(day: day)
                    }
                }
            }
            .navigationTitle("Weekly Plan")
        }
        .sheet(isPresented: $showingPlanBuilder) {
            PlanBuilderView(showingPlanBuilder: $showingPlanBuilder)
        }
    }
}

#Preview {
    WeekView()
        .modelContainer(DataController.previewContainer)
}
