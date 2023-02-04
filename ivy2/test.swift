//
//  test.swift
//  neaam
//
//  Created by Sara Khalid BIN kuddah on 12/07/1444 AH.
//

import SwiftUI

struct test: View {
   //, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25
            @State var entries = [1, 2, 3, 4, 5, 6]
            @State var currentSelection: Int? = nil
    
    func getHabitName(num:Int) -> String{
        let liveAlbums = num
        switch liveAlbums {
        case 1:
           return "Volunteering"
        case 2:
            return "Plastic Reduction"

        case 3:
            return "Sustainable"
        case 4:
            return "Recycling"
        case 5:
            return "Planting"
        default:
            return "Safe Energy"
        
        }
    }
    func getHabitDetails(num:Int) -> String{
        let liveAlbums = num
        switch liveAlbums {
        case 1:
           return " Volunteering is a voluntary act of an individual or group freely giving time and labor for community service."
        case 2:
            return "The benefits of reducing plastic consumption include: Preventing pollution by lessening the amount of new raw materials used. Saves energy."

        case 3:
            return "Being committed to sustainability will reduce your carbon footprint and the amount of toxins released into the environment, making it safe. When we focus on sustainability, the entire world benefits and gets to live in clean, more healthy living conditions."
        case 4:
            return "Recycling is the process of collecting and processing materials ,that would otherwise be thrown away as trash and remanufacturing them into new products."
        case 5:
            return ":Plants act as highly effective air cleaners, absorbing carbon dioxide, plus many air pollutants, while releasing clean oxygen and fragrance."
        default:
            return "Saving energy reduces air and water pollution and conserves natural resources, which in turn creates a healthier living environment for people everywhere."
        
        }
    }
    let habit = Habit()
    
    
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
            var body: some View {
                NavigationView {
                    ZStack {
                        EmptyNavigationLink(
                            destination: { DetailView(coreDM: CoreDateManager(), currentHabitName: getHabitName(num: $0),currentHabitDetails: getHabitDetails(num: $0),habit: habit) },
                            selection: $currentSelection
                        )
                       // Form {
                        ScrollView {
                            LazyVGrid(columns: gridItemLayout, spacing: 50) {
                                ForEach(entries.sorted(), id: \.self) { entry in
                                    NavigationLink(
                                        destination: DetailView(coreDM: CoreDateManager(), currentHabitName: getHabitName(num: entry),currentHabitDetails: getHabitDetails(num: entry),habit: habit),
                                        label: { Text(" \(entry) - \(getHabitName(num: entry))")
                                            
                                        })
                                }
                            }
                           
                        }

                      //  }
                        .toolbar {
                            ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) { Button("Add low") {
                                let newEntry = (entries.min() ?? 1) - 1
                                entries.insert(newEntry, at: 1)
                                currentSelection = newEntry
                            } }
                            ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) { Button("Add high") {
                                let newEntry = (entries.max() ?? 50) + 1
                                entries.append(newEntry)
                                currentSelection = newEntry
                            } }
                            ToolbarItem(placement: ToolbarItemPlacement.bottomBar) {
                                Text("The current selection is \(String(describing: currentSelection))")
                            }
                        }
                    }
                }
            }
        }

        struct DetailView: View {
            let coreDM: CoreDateManager
            @State private var habitName: String = ""
            @State private var habits: [Habit] = [Habit]()
            private func populateHabits(){
                habits = coreDM.getAllHabits()
            }
            
            let currentHabitName: String
            let currentHabitDetails: String
            let habit: Habit
            //for update
            
            var body: some View {
                NavigationView{
                    VStack{
                        Text("Habit Name:")
                        Text("\(currentHabitName)")
                        Text("Habit Details:")
                        Text("\(currentHabitDetails)")
                        
//                        TextField("Enter Habit ", text:$habitName)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("Did you contorbute ?")
                        Button("yes"){
                            if(coreDM.isItOnCoredata(name: currentHabitName).name != "no" ){
                                let currentHabit = coreDM.isItOnCoredata(name: currentHabitName)
                                currentHabit.points = currentHabit.points + 5
                                coreDM.updateHabit()
                                
                                populateHabits()
                            }else{
                                //create new Habit
                                coreDM.saveHabit(name: currentHabitName, points: 5)
                                populateHabits()
                            }
                        }
                        Spacer()
                        List(habits, id: \.self){
                            habit in
                            Text(habit.name ?? "")
                            Text("habit.points : \(habit.points)")
                        }
                    }.padding()
                        .navigationTitle("Habit")
                    
                        .onAppear(perform: {
                           populateHabits()
                        })

                }
            }
        }

        public struct LazyView<Content: View>: View {
            private let build: () -> Content
            public init(_ build: @autoclosure @escaping () -> Content) {
                self.build = build
            }
            public var body: Content {
                build()
            }
        }

        struct EmptyNavigationLink<Destination: View>: View {
            let lazyDestination: LazyView<Destination>
            let isActive: Binding<Bool>
            
            init<T>(
                @ViewBuilder destination: @escaping (T) -> Destination,
                selection: Binding<T?>
            )  {
                lazyDestination = LazyView(destination(selection.wrappedValue!))
                isActive = .init(
                    get: { selection.wrappedValue != nil },
                    set: { isActive in
                        if !isActive {
                            selection.wrappedValue = nil
                        }
                    }
                )
            }
            
            var body: some View {
                NavigationLink(
                    destination: lazyDestination,
                    isActive: isActive,
                    label: { EmptyView() }
                )
            }
        }
    
struct EntrieButton:View{
    @State var showSheet = false
    var entry:String

    var body: some View {
        Button(action:{self.showSheet = true}){
            Text(entry)
        }.sheet(isPresented: $showSheet){
            
                VStack {
                    Text("My Sheet number \(entry)")
                   
                }
            
            
        }
    }
}

struct test_Previews: PreviewProvider {
    static var previews: some View {
        test()
    }
}
