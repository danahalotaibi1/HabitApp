//
//  ContentView.swift
//  HabitApp
//
//  Created by Fahdah Alsamari on 17/12/1447 AH.
//

import SwiftUI

struct ContentView: View {
    @State private var runningCompleted = 0
    @State private var waterCompleted = 0
    @State private var readingCompleted = 0
    @State private var openedMenu: String? = nil
    @State private var selectedCard = 1

    var body: some View {
        ZStack {
            ZStack(alignment: .topLeading) {
                Color("BackgroundCream")
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 8) {
                    Text("DAILY HABITS")
                        .font(.system(size: 16, weight: .regular, design: .serif))
                        .foregroundColor(Color("PrimaryOrange"))

                    Text("KEEP GOING!🔥")
                        .font(.system(size: 25, weight: .bold, design: .serif))
                        .foregroundColor(.black)
                }
                .padding(.top, 25)
                .padding(.leading, 28)
                .blur(radius: openedMenu == nil ? 0 : 6)

                VStack {
                    HStack {
                        Spacer()

                        Button(action: {
                            // Add Habit
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color("BackgroundCream"))
                                    .frame(width: 64, height: 63)
                                    .overlay(
                                        Circle()
                                            .stroke(
                                                Color("PrimaryOrange").opacity(0.23),
                                                lineWidth: 1
                                            )
                                    )
                                    .overlay(
                                        Circle()
                                            .stroke(
                                                LinearGradient(
                                                    colors: [
                                                        Color("PrimaryOrange").opacity(0.65),
                                                        Color("PrimaryOrange").opacity(0.18),
                                                        Color("PrimaryOrange").opacity(0.08),
                                                        Color("PrimaryOrange").opacity(0.18)
                                                    ],
                                                    startPoint: .top,
                                                    endPoint: .bottom
                                                ),
                                                lineWidth: 2.2
                                            )
                                            .blur(radius: 0.6)
                                    )
                                    .shadow(
                                        color: Color("PrimaryOrange").opacity(0.18),
                                        radius: 9,
                                        x: 0,
                                        y: 1
                                    )

                                Image(systemName: "plus")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(Color("PrimaryOrange"))
                            }
                        }
                    }

                    Spacer()
                }
                .padding(.top, 32)
                .padding(.trailing, 28)
                .blur(radius: openedMenu == nil ? 0 : 6)

                VStack {
                    Spacer()
                        .frame(height: 250)

                    HabitCarousel(
                        selectedCard: $selectedCard,
                        openedMenu: $openedMenu,
                        runningCompleted: $runningCompleted,
                        waterCompleted: $waterCompleted,
                        readingCompleted: $readingCompleted
                    )
                    .blur(radius: openedMenu == nil ? 0 : 6)
                }
            }

            if openedMenu != nil {
                Color.black.opacity(0.12)
                    .ignoresSafeArea()
                    .onTapGesture {
                        openedMenu = nil
                    }

                HabitMenu()
            }
        }
    }
}

struct HabitCarousel: View {
    @Binding var selectedCard: Int
    @Binding var openedMenu: String?
    @Binding var runningCompleted: Int
    @Binding var waterCompleted: Int
    @Binding var readingCompleted: Int

    var body: some View {
        VStack(spacing: 22) {
            GeometryReader { geo in
                ZStack {
                    carouselCard(
                        index: 0,
                        title: "Running",
                        icon: "🏃🏻‍♀️",
                        completed: $runningCompleted,
                        total: 1
                    )

                    carouselCard(
                        index: 1,
                        title: "Drinking water",
                        icon: "💧",
                        completed: $waterCompleted,
                        total: 8
                    )

                    carouselCard(
                        index: 2,
                        title: "Reading",
                        icon: "📚",
                        completed: $readingCompleted,
                        total: 1
                    )
                }
                .frame(width: geo.size.width, height: 325)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width < -40 && selectedCard < 2 {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    selectedCard += 1
                                }
                            }

                            if value.translation.width > 40 && selectedCard > 0 {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    selectedCard -= 1
                                }
                            }
                        }
                )
            }
            .frame(height: 325)

            HStack(spacing: 14) {
                Circle()
                    .fill(selectedCard == 0 ? Color.black : Color.gray.opacity(0.55))
                    .frame(width: 12, height: 12)

                Circle()
                    .fill(selectedCard == 1 ? Color.black : Color.gray.opacity(0.55))
                    .frame(width: 12, height: 12)

                Circle()
                    .fill(selectedCard == 2 ? Color.black : Color.gray.opacity(0.55))
                    .frame(width: 12, height: 12)
            }
        }
    }

    func carouselCard(
        index: Int,
        title: String,
        icon: String,
        completed: Binding<Int>,
        total: Int
    ) -> some View {
        let isSelected = selectedCard == index
        let cardGap: CGFloat = 34
        let selectedWidth: CGFloat = 222
        let smallWidth: CGFloat = 110
        let xOffset = CGFloat(index - selectedCard) * ((selectedWidth / 2) + (smallWidth / 2) + cardGap)

        return HabitCard(
            title: title,
            icon: icon,
            completed: completed,
            total: total,
            openedMenu: $openedMenu,
            isSelected: isSelected
        )
        .frame(
            width: isSelected ? 222 : 110,
            height: isSelected ? 294 : 275
        )
        .offset(
            x: xOffset,
            y: isSelected ? -8 : 12
        )
        .zIndex(isSelected ? 2 : 1)
        .animation(.easeInOut(duration: 0.25), value: selectedCard)
        .onTapGesture {
            if isSelected {
                if completed.wrappedValue < total {
                    completed.wrappedValue += 1
                }
            } else {
                withAnimation(.easeInOut(duration: 0.25)) {
                    selectedCard = index
                }
            }
        }
    }
}

struct HabitCard: View {
    let title: String
    let icon: String
    @Binding var completed: Int
    let total: Int
    @Binding var openedMenu: String?
    let isSelected: Bool

    var progress: Double {
        Double(completed) / Double(total)
    }

    var isCompleted: Bool {
        completed >= total
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()

                Button(action: {
                    if isSelected {
                        openedMenu = title
                    }
                }) {
                    Text("•••")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.gray)
                        .padding(.trailing, 14)
                        .padding(.top, 12)
                }
                .disabled(!isSelected)
            }

            Text(title)
                .font(.system(size: 20, weight: .bold, design: .serif))
                .foregroundColor(.black)
                .padding(.top, 2)
                .lineLimit(1)

            Spacer()
                .frame(height: 36)

            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.20), lineWidth: 4)
                    .frame(width: 95, height: 95)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        Color("PrimaryOrange"),
                        style: StrokeStyle(lineWidth: 4, lineCap: .butt)
                    )
                    .frame(width: 95, height: 95)
                    .rotationEffect(.degrees(-90))

                Text(icon)
                    .font(.system(size: 36))
            }

            Spacer()
                .frame(height: 28)

            if isCompleted {
                Text("Completed")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.top, 18)
            } else {
                Circle()
                    .fill(completed > 0 ? Color("PrimaryOrange") : Color.clear)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .stroke(Color("PrimaryOrange"), lineWidth: 2)
                    )
                    .overlay(
                        Group {
                            if completed > 0 {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 26, weight: .regular))
                                    .foregroundColor(.white)
                            }
                        }
                    )

                Text("\(completed) out of \(total)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.top, 8)
            }

            Spacer()
        }
        .background(Color("Card"))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        .clipped()
    }
}

struct HabitMenu: View {
    var body: some View {
        VStack(spacing: 0) {
            MenuRow(title: "Freeze", icon: "snowflake", color: .black)
            Divider()

            MenuRow(title: "Edit", icon: "pencil", color: .black)
            Divider()

            MenuRow(title: "Delete", icon: "trash", color: .red)
        }
        .frame(width: 230)
        .background(.ultraThinMaterial)
        .cornerRadius(22)
        .shadow(color: .black.opacity(0.12), radius: 18, x: 0, y: 8)
    }
}

struct MenuRow: View {
    let title: String
    let icon: String
    let color: Color

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(color)

            Spacer()

            Image(systemName: icon)
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(color)
        }
        .padding(.horizontal, 24)
        .frame(height: 56)
    }
}

#Preview {
    ContentView()
}
