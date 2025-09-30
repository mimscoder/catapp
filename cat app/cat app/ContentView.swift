//
//  ContentView.swift
//  cat app
//
//  Created by Mimi Chen on 9/29/25.
//

import SwiftUI
import AVFoundation

// MARK: - View Extension for Placeholder
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

// MARK: - Sound Manager
import AudioToolbox

class SoundManager: ObservableObject {
    static let shared = SoundManager()
    
    func playSound(_ soundName: String) {
        let soundID: SystemSoundID
        
        switch soundName {
        case "button_tap":
            soundID = 1104 // Tock sound
        case "character_select":
            soundID = 1105 // Pop sound
        case "button_confirm":
            soundID = 1057 // Alert sound
        case "trait_select":
            soundID = 1306 // Key press sound
        case "trait_deselect":
            soundID = 1306 // Key press sound
        case "traits_complete":
            soundID = 1054 // Tweet sound (success)
        case "welcome":
            soundID = 1303 // New mail sound
        case "success":
            soundID = 1025 // Fanfare/success
        default:
            return
        }
        
        AudioServicesPlaySystemSound(soundID)
    }
}

// MARK: - Haptic Manager
#if os(iOS)
import UIKit

class HapticManager {
    static let shared = HapticManager()
    
    func light() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func medium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func heavy() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func warning() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    
    func error() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
#else
// macOS fallback - no haptics
class HapticManager {
    static let shared = HapticManager()
    func light() {}
    func medium() {}
    func heavy() {}
    func success() {}
    func warning() {}
    func error() {}
    func selection() {}
}
#endif

// MARK: - Content View
struct ContentView: View {
    var body: some View {
        NavigationView {
            WelcomeView()
        }
        .navigationViewStyle(.stack)
    }
}

// MARK: - Welcome View
struct WelcomeView: View {
    @State private var showTitle = false
    @State private var showSubtitle = false
    @State private var showButton = false
    @State private var leafAnimation = false
    @State private var bellAnimation = false
    
    var body: some View {
        ZStack {
            // background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.7, green: 0.9, blue: 1.0),
                    Color(red: 0.5, green: 0.8, blue: 0.3)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // floating clouds
            CloudsView()
            
            // main content
            VStack(spacing: 30) {
                Spacer()
                
                VStack {
                    ZStack {
                        Circle()
                            .fill(Color(.white))
                            .opacity(0.5)
                            .frame(width: 120, height: 120)
                            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                        
                        Image("mimizook")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                    }
                    .scaleEffect(showTitle ? 1.0 : 0.5)
                    .animation(.spring(response: 0.8, dampingFraction: 0.6), value: showTitle)
                }
                
                // Welcome text
                VStack(spacing: 12) {
                    Text("welcome to")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1))
                        .opacity(showSubtitle ? 1.0 : 0.0)
                        .offset(y: showSubtitle ? 0 : 20)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: showSubtitle)
                    
                    Text("cat village")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.1))
                        .multilineTextAlignment(.center)
                        .opacity(showTitle ? 1.0 : 0.0)
                        .offset(y: showTitle ? 0 : 30)
                        .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.5), value: showTitle)
                    
                    Text("your new island adventure awaits!")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.2))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .opacity(showSubtitle ? 1.0 : 0.0)
                        .offset(y: showSubtitle ? 0 : 20)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.7), value: showSubtitle)
                }
                
                Spacer()
                
                // Decorative elements
                HStack(spacing: 20) {
                    LeafView()
                        .scaleEffect(leafAnimation ? 1.1 : 0.9)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: leafAnimation)
                    
                    Image(systemName: "pawprint.fill")
                        .font(.title)
                        .foregroundColor(.brown)
                        .scaleEffect(bellAnimation ? 1.3 : 1.0)
                        .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: bellAnimation)
                    
                    LeafView()
                        .scaleEffect(leafAnimation ? 0.9 : 1.1)
                        .animation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true), value: leafAnimation)
                }
                .opacity(showButton ? 1.0 : 0.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.0), value: showButton)
                
                // Get Started button
                NavigationLink(destination: CharacterSelectionView()) {
                    HStack {
                        Text("get started")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color(red: 0.2, green: 0.6, blue: 0.3))
                            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                    )
                }
                .simultaneousGesture(TapGesture().onEnded {
                    SoundManager.shared.playSound("button_tap")
                    HapticManager.shared.medium()
                })
                .scaleEffect(showButton ? 1.0 : 0.8)
                .opacity(showButton ? 1.0 : 0.0)
                .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(1.2), value: showButton)
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            withAnimation {
                showTitle = true
                showSubtitle = true
                showButton = true
                leafAnimation = true
                bellAnimation = true
            }
            
            // Haptic feedback when button appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                HapticManager.shared.light()
            }
        }
    }
}

// MARK: - Clouds View
struct CloudsView: View {
    @State private var cloudOffset1: CGFloat = -100
    @State private var cloudOffset2: CGFloat = -150
    @State private var cloudOffset3: CGFloat = -200
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack {
                    Spacer()
                    CloudShape()
                        .fill(.white.opacity(0.8))
                        .frame(width: 80, height: 40)
                        .offset(x: cloudOffset1)
                        .animation(.linear(duration: 20).repeatForever(autoreverses: false), value: cloudOffset1)
                }
                .offset(y: -200)
                
                HStack {
                    CloudShape()
                        .fill(.white.opacity(0.6))
                        .frame(width: 60, height: 30)
                        .offset(x: cloudOffset2)
                        .animation(.linear(duration: 25).repeatForever(autoreverses: false), value: cloudOffset2)
                    Spacer()
                }
                .offset(y: -150)
                
                HStack {
                    Spacer()
                    CloudShape()
                        .fill(.white.opacity(0.7))
                        .frame(width: 70, height: 35)
                        .offset(x: cloudOffset3)
                        .animation(.linear(duration: 18).repeatForever(autoreverses: false), value: cloudOffset3)
                }
                .offset(y: -250)
            }
            .onAppear {
                cloudOffset1 = geometry.size.width + 100
                cloudOffset2 = geometry.size.width + 150
                cloudOffset3 = geometry.size.width + 200
            }
        }
    }
}

// MARK: - Cloud Shape
struct CloudShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.addEllipse(in: CGRect(x: 0, y: height * 0.3, width: width * 0.6, height: height * 0.7))
        path.addEllipse(in: CGRect(x: width * 0.2, y: 0, width: width * 0.6, height: height * 0.8))
        path.addEllipse(in: CGRect(x: width * 0.4, y: height * 0.2, width: width * 0.6, height: height * 0.8))
        
        return path
    }
}

// MARK: - Leaf View
struct LeafView: View {
    var body: some View {
        Image(systemName: "leaf.fill")
            .font(.title)
            .foregroundColor(Color(red: 0.3, green: 0.7, blue: 0.2))
            .shadow(color: .black.opacity(0.2), radius: 2, x: 1, y: 1)
    }
}

// MARK: - Character Selection View
struct CharacterSelectionView: View {
    @State private var selectedCharacter: Int? = nil
    @Environment(\.presentationMode) var presentationMode
    
    let characters = [
        Character(id: 0, name: "strawberry siamese"),
        Character(id: 1, name: "peach\nragdoll"),
        Character(id: 2, name: "apple\ncalico"),
        Character(id: 3, name: "blueberry shorthair")
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.95, green: 0.98, blue: 1.0),
                    Color(red: 0.9, green: 0.95, blue: 0.9)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 32) {
                HStack {
                    Button(action: {
                        SoundManager.shared.playSound("button_tap")
                        HapticManager.shared.light()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .fontWeight(.medium)
                            Text("Back")
                                .font(.title3)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.3))
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 44)
                .padding(.top, 20)
                
                VStack(spacing: 12) {
                    Text("choose your fruit cat")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.1))
                    
                    Text("pick the one that matches you best")
                        .font(.title3)
                        .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.2))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 44)
                
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        CharacterCard(
                            character: characters[0],
                            isSelected: selectedCharacter == characters[0].id
                        ) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                selectedCharacter = characters[0].id
                            }
                            SoundManager.shared.playSound("character_select")
                            HapticManager.shared.selection()
                        }
                        
                        CharacterCard(
                            character: characters[1],
                            isSelected: selectedCharacter == characters[1].id
                        ) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                selectedCharacter = characters[1].id
                            }
                            SoundManager.shared.playSound("character_select")
                            HapticManager.shared.selection()
                        }
                    }
                    
                    HStack(spacing: 12) {
                        CharacterCard(
                            character: characters[2],
                            isSelected: selectedCharacter == characters[2].id
                        ) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                selectedCharacter = characters[2].id
                            }
                            SoundManager.shared.playSound("character_select")
                            HapticManager.shared.selection()
                        }
                        
                        CharacterCard(
                            character: characters[3],
                            isSelected: selectedCharacter == characters[3].id
                        ) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                selectedCharacter = characters[3].id
                            }
                            SoundManager.shared.playSound("character_select")
                            HapticManager.shared.selection()
                        }
                    }
                }
                .padding(.horizontal, 70)
                
                Spacer()
                
                HStack {
                    NavigationLink(destination: OnboardingView()) {
                        HStack {
                            Text("continue adventure")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(
                                    selectedCharacter != nil ?
                                    Color(red: 0.2, green: 0.6, blue: 0.3) :
                                    Color.gray.opacity(0.6)
                                )
                                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                        )
                    }
                    .disabled(selectedCharacter == nil)
                    .simultaneousGesture(TapGesture().onEnded {
                        if selectedCharacter != nil {
                            SoundManager.shared.playSound("button_tap")
                            HapticManager.shared.medium()
                        } else {
                            HapticManager.shared.warning()
                        }
                    })
                }
                .padding(.horizontal, 70)
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Character Model
struct Character {
    let id: Int
    let name: String
}

// MARK: - Character Card
struct CharacterCard: View {
    let character: Character
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 15) {
                Image(getImageName(for: character.id))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                
                Text(character.name)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1))
                    .multilineTextAlignment(.center)
            }
            .frame(width: 140, height: 160)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                isSelected ? Color(red: 0.2, green: 0.6, blue: 0.3) : Color.clear,
                                lineWidth: 3
                            )
                    )
            )
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isSelected)
    }
    
    private func getImageName(for id: Int) -> String {
        switch id {
        case 0: return "strawberry siamese"
        case 1: return "peach ragdoll"
        case 2: return "apple calico"
        case 3: return "blueberry british"
        default: return "strawberry siamese"
        }
    }
}

// MARK: - Custom Text Field Style
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(15)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            )
            .font(.body)
            .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1))
            .accentColor(Color(red: 0.2, green: 0.6, blue: 0.3))
    }
}

// MARK: - Onboarding View
struct OnboardingView: View {
    @State private var characterName: String = ""
    @State private var selectedTraits: Set<Int> = []
    @Environment(\.presentationMode) var presentationMode
    
    let personalityTraits = [
        PersonalityTrait(id: 0, name: "creative", color: Color(red: 0.9, green: 0.6, blue: 0.8)),
        PersonalityTrait(id: 1, name: "clingy", color: Color(red: 0.6, green: 0.8, blue: 0.9)),
        PersonalityTrait(id: 2, name: "friendly", color: Color(red: 1.0, green: 0.8, blue: 0.6)),
        PersonalityTrait(id: 3, name: "bubbly", color: Color(red: 0.7, green: 0.9, blue: 0.6)),
        PersonalityTrait(id: 4, name: "sneaky", color: Color(red: 0.8, green: 0.7, blue: 0.9)),
        PersonalityTrait(id: 5, name: "silly", color: Color(red: 1.0, green: 0.7, blue: 0.7)),
        PersonalityTrait(id: 6, name: "curious", color: Color(red: 0.6, green: 0.9, blue: 0.8)),
        PersonalityTrait(id: 7, name: "peaceful", color: Color(red: 0.8, green: 0.9, blue: 0.7)),
        PersonalityTrait(id: 8, name: "social", color: Color(red: 0.9, green: 0.8, blue: 0.6)),
        PersonalityTrait(id: 9, name: "cuddly", color: Color(red: 0.7, green: 0.8, blue: 1.0)),
        PersonalityTrait(id: 10, name: "empath", color: Color(red: 0.9, green: 0.7, blue: 0.8)),
        PersonalityTrait(id: 11, name: "sleepy", color: Color(red: 0.8, green: 0.8, blue: 0.9))
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.95, green: 0.98, blue: 1.0),
                    Color(red: 0.9, green: 0.95, blue: 0.9)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    HStack {
                        Button(action: {
                            SoundManager.shared.playSound("button_tap")
                            HapticManager.shared.light()
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                Text("Back")
                                    .font(.title3)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.3))
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    VStack(spacing: 12) {
                        Text("customize your cat")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.1))
                            .multilineTextAlignment(.center)
                        
                        Text("give your cat a name and pick 3 personality traits")
                            .font(.title3)
                            .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.2))
                            .multilineTextAlignment(.center)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("cat name")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1))
                        
                        ZStack(alignment: .leading) {
                            if characterName.isEmpty {
                                Text("enter character name")
                                    .foregroundColor(Color(red: 0.5, green: 0.4, blue: 0.3))
                                    .padding(.leading, 15)
                            }
                            TextField("", text: $characterName)
                                .textFieldStyle(CustomTextFieldStyle())
                                .autocapitalization(.words)
                                .onChange(of: characterName) { oldValue, newValue in
                                    HapticManager.shared.selection()
                                }
                        }
                    }
                    .padding(.horizontal, 44)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(spacing: 4) {
                            Text("personality traits")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1))
                            
                            Text("select 3 traits (\(selectedTraits.count)/3)")
                                .font(.subheadline)
                                .foregroundColor(Color(red: 0.5, green: 0.4, blue: 0.3))
                        }
                        .padding(.horizontal, 44)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 2),
                            GridItem(.flexible(), spacing: 2),
                            GridItem(.flexible(), spacing: 2)
                        ], spacing: 8) {
                            ForEach(personalityTraits, id: \.id) { trait in
                                TraitChip(
                                    trait: trait,
                                    isSelected: selectedTraits.contains(trait.id),
                                    isDisabled: !selectedTraits.contains(trait.id) && selectedTraits.count >= 3
                                ) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        if selectedTraits.contains(trait.id) {
                                            selectedTraits.remove(trait.id)
                                            SoundManager.shared.playSound("trait_deselect")
                                            HapticManager.shared.light()
                                        } else if selectedTraits.count < 3 {
                                            selectedTraits.insert(trait.id)
                                            SoundManager.shared.playSound("trait_select")
                                            HapticManager.shared.selection()
                                            
                                            if selectedTraits.count == 3 {
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                    HapticManager.shared.success()
                                                }
                                            }
                                        } else {
                                            HapticManager.shared.warning()
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 44)
                        Spacer()
                    }
                    
                    NavigationLink(destination: FinalView()) {
                        HStack {
                            Text("complete setup")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 40)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(
                                    canContinue ?
                                    Color(red: 0.2, green: 0.6, blue: 0.3) :
                                    Color.gray.opacity(0.6)
                                )
                                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                        )
                    }
                    .disabled(!canContinue)
                    .simultaneousGesture(TapGesture().onEnded {
                        if canContinue {
                            SoundManager.shared.playSound("button_tap")
                            HapticManager.shared.medium()
                        } else {
                            HapticManager.shared.warning()
                        }
                    })
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private var canContinue: Bool {
        !characterName.isEmpty && selectedTraits.count == 3
    }
}

// MARK: - Personality Trait Model
struct PersonalityTrait {
    let id: Int
    let name: String
    let color: Color
}

// MARK: - Trait Chip
struct TraitChip: View {
    let trait: PersonalityTrait
    let isSelected: Bool
    let isDisabled: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(trait.name)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(
                    isSelected ? .white :
                    isDisabled ? .gray :
                    Color(red: 0.3, green: 0.2, blue: 0.1)
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            isSelected ? trait.color :
                            isDisabled ? Color.gray.opacity(0.3) :
                            Color.white
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(
                                    isSelected ? trait.color :
                                    isDisabled ? Color.gray.opacity(0.5) :
                                    trait.color.opacity(0.6),
                                    lineWidth: 2
                                )
                        )
                        .shadow(
                            color: isSelected ? trait.color.opacity(0.3) : .black.opacity(0.1),
                            radius: isSelected ? 6 : 4,
                            x: 0,
                            y: isSelected ? 4 : 2
                        )
                )
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .opacity(isDisabled ? 0.6 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        .disabled(isDisabled)
    }
}

// MARK: - Final View
struct FinalView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.95, green: 0.98, blue: 1.0),
                    Color(red: 0.9, green: 0.95, blue: 0.9)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    HStack {
                        Button(action: {
                            SoundManager.shared.playSound("button_tap")
                            HapticManager.shared.light()
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                Text("Back")
                                    .font(.title3)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.3))
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    VStack(spacing: 12) {
                        Text("your new island adventure awaits!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.1))
                            .multilineTextAlignment(.center)
                        Text("create your account")
                            .font(.title3)
                            .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.2))
                            .multilineTextAlignment(.center)
                    }.padding(.horizontal, 44)
                    
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("username")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1))
                            
                            ZStack(alignment: .leading) {
                                if username.isEmpty {
                                    Text("enter username")
                                        .foregroundColor(Color(red: 0.5, green: 0.4, blue: 0.3))
                                        .padding(.leading, 15)
                                }
                                TextField("", text: $username)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)
                                    .onChange(of: username) { oldValue, newValue in
                                        HapticManager.shared.selection()
                                    }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("password")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1))
                            
                            ZStack(alignment: .leading) {
                                if password.isEmpty {
                                    Text("enter password")
                                        .foregroundColor(Color(red: 0.5, green: 0.4, blue: 0.3))
                                        .padding(.leading, 15)
                                }
                                SecureField("", text: $password)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .onChange(of: password) { oldValue, newValue in
                                        HapticManager.shared.selection()
                                    }
                            }
                        }
                    }
                    .padding(.horizontal, 44)
                    
                    NavigationLink(destination: AnimalCrossingChatView()) {
                        HStack {
                            Text("join the village")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Image(systemName: "house.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 40)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(
                                    canJoinVillage ?
                                    Color(red: 0.2, green: 0.6, blue: 0.3) :
                                    Color.gray.opacity(0.6)
                                )
                                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                        )
                    }
                    .disabled(!canJoinVillage)
                    .simultaneousGesture(TapGesture().onEnded {
                        if canJoinVillage {
                            SoundManager.shared.playSound("button_tap")
                            HapticManager.shared.success()
                            
                            // Celebration haptic sequence
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                HapticManager.shared.light()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                HapticManager.shared.medium()
                            }
                        }
                    })
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private var canJoinVillage: Bool {
        !username.isEmpty && !password.isEmpty
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: - Animal Crossing Chat View
struct AnimalCrossingChatView: View {
    @State private var currentText = ""
    private let fullText = "hi, welcome to cat village! zuko and I are so excited you are joining us today~"
    
    var body: some View {
        ZStack {
            // Background
            Image("animal crossing background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            // Character positioned in the scene
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    Image("mimizook")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                        .padding(.trailing, 80)
                        .padding(.bottom, 225)
                }
            }
            
            // Bottom dialogue area
            VStack {
                Spacer()
                
                VStack(spacing: 5) {
                    // Character name bar
                    HStack {
                        Spacer()
                        Text("Mimi")
                            .font(.custom("Arial", size: 16))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color(red: 0.3, green: 0.5, blue: 0.7))
                            )
                    }
                    .padding(.horizontal, 20)
                    
                    // Main dialogue box
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(red: 0.2, green: 0.3, blue: 0.5))
                            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                        
                        HStack {
                            Text(currentText)
                                .font(.custom("Arial", size: 18))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal, 25)
                                .padding(.vertical, 20)
                                .lineLimit(nil)
                            Spacer()
                        }
                    }
                    .frame(height: 120)
                    .padding(.horizontal, 20)
                    
                    // Start Playing button
                    HStack {
                        Spacer()
                        Button(action: {
                            SoundManager.shared.playSound("button_tap")
                            HapticManager.shared.medium()
                            // Add action for starting game here
                        }) {
                            HStack {
                                Text("start playing")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 40)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color(red: 0.2, green: 0.6, blue: 0.3))
                                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                            )
                        }
                        .padding(.trailing, 20)
                    }
                    .padding(.top, 10)
                }
                
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 40)
            }
        }
        .navigationBarHidden(true)
        .onTapGesture {
            if currentText != fullText {
                currentText = fullText
            }
        }
        .onAppear {
            typeWriterEffect()
        }
    }
    
    private func typeWriterEffect() {
        currentText = ""
        let characters = Array(fullText)
        
        for (index, character) in characters.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.04) {
                currentText += String(character)
            }
        }
    }
}
