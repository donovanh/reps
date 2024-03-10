import SwiftUI
import SwiftData

struct PlanBuilderView: View {
    
    // TODO: Back button
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    @State var dayViewModel: DayView.ViewModel
    @Binding var isEditMode: Bool
    
    @State private var formStep: Int = 1
    @State private var experienceLevelOption: ExperienceLevel = ExperienceLevel.gettingStarted
    @State private var scheduleOption: Schedule = Schedule.defaultSchedule
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    if formStep == 1 {
                        Text("Exercise level")
                    }
                    if formStep == 2 {
                        Text("Weekly schedule")
                    }
                    if formStep == 3 {
                        Text("Confirm your plan")
                    }
                }
                .font(.title.bold())
                .padding()
                .padding(.top, 40)
                Form {
                    if formStep == 1 {
                        Section("Choose your progression level") {
                            Picker("Progression levels", selection: $experienceLevelOption) {
                                ForEach(ExperienceLevel.allCases, id: \.self) { level in
                                    Text(level.rawValue).tag(level)
                                        .id(level)
                                }
                            }
                            .labelsHidden()
                            .pickerStyle(.inline)
                        }
                        .listRowBackground(Color.themeColor.opacity(0.1))
                        LevelOverviewView(level: $experienceLevelOption)
                            .listRowBackground(Color.themeColor.opacity(0.1))
                    }
                    if formStep == 2 {
                        Section("Choose a weekly schedule") {
                            Picker("Choose your weekly plan", selection: $scheduleOption) {
                                ForEach(Schedule.allCases, id: \.self) { schedule in
                                    Text(schedule.rawValue).tag(schedule)
                                        .id(schedule)
                                }
                            }
                            .labelsHidden()
                            .pickerStyle(.inline)
                        }
                        .listRowBackground(Color.themeColor.opacity(0.1))
                        ScheduleOverviewView(scheduleOption: $scheduleOption, experienceLevelOption: $experienceLevelOption)
                            .listRowBackground(Color.themeColor.opacity(0.1))
                    }
                    if formStep == 3 {
                        Section("Apply new plan") {
                            PlanOverviewView(schedule: $scheduleOption, level: $experienceLevelOption)
                            LevelOverviewView(level: $experienceLevelOption, showDescription: false)
                                .listRowBackground(Color.themeColor.opacity(0.1))
                            ScheduleOverviewView(scheduleOption: $scheduleOption, experienceLevelOption: $experienceLevelOption, showDescription: false)
                                .listRowBackground(Color.themeColor.opacity(0.1))
                        }
                    }
                }
                HStack {
                    if formStep == 1 {
                        Spacer()
                        Button("Choose a schedule") {
                            withAnimation {
                                formStep = 2
                            }
                        }
                        Spacer()
                    }
                    if formStep == 2 {
                        Button("Next") {
                            withAnimation {
                                formStep = 3
                            }
                        }
                    }
                    if formStep == 3 {
                        Button("Apply this plan") {
                            applyPlan()
                        }
                    }
                }
                .tint(.themeColor)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .frame(maxWidth: .infinity)
                .padding()
                   
            }
            Section {
                VStack {
                    HStack {
                        if formStep > 1 {
                            Button("Go back") {
                                withAnimation {
                                    formStep = formStep == 3 ? 2 : 1
                                }
                            }
                            .buttonStyle(.bordered)
                            .foregroundColor(.themeColor)
                            .controlSize(.small)
                            .tint(Color.themeColor)
                            .padding()
                        }
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                        }
                        .foregroundColor(.secondary)
                        .controlSize(.large)
                        .tint(Color.themeColor)
                        .padding()
                    }
                    Spacer()
                }
            }
        }
        .scrollContentBackground(.hidden)
        .containerRelativeFrame([.horizontal, .vertical])
        .background(colorScheme == .dark ? Color.darkBg : Color.lightBg)
    }
    
    func applyPlan() {
        dayViewModel.setStages(to: stagesByExperienceLevel[experienceLevelOption]!)
        dayViewModel.setWeeklySchedule(typeByDay: weekSchedules[scheduleOption]!)
        isEditMode = false
        dismiss()
    }
}

#Preview {
    PlanBuilderView(
        dayViewModel: DayView.ViewModel(),
        isEditMode: .constant(false)
    )
    .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
