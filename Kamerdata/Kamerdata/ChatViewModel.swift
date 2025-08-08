import Foundation

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var userInput: String = ""
    @Published var isLoading = false

    func sendMessage() async {
        let trimmed = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        messages.append(Message(text: trimmed, isUser: true, timestamp: Date()))
        userInput = ""
        isLoading = true

        do {
            let reply = try await fetchResponse(for: trimmed)
            messages.append(Message(text: reply, isUser: false, timestamp: Date()))
        } catch {
            messages.append(Message(text: "⚠️ Fout bij ophalen antwoord.", isUser: false, timestamp: Date()))
        }

        isLoading = false
    }

    private func fetchResponse(for question: String) async throws -> String {
        // For now, return a mock response since the API endpoint is not configured
        // In a real app, you would replace this with your actual API endpoint
        return "Dit is een demo antwoord op je vraag: '\(question)'. Configureer een echte API endpoint in ChatViewModel.swift"
    }
}