import SwiftUI

struct ChatView: View {
    @StateObject private var vm = ChatViewModel()

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(vm.messages) { msg in
                            HStack {
                                if msg.isUser { Spacer() }
                                Text(msg.text)
                                    .padding()
                                    .background(msg.isUser ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                                    .cornerRadius(12)
                                    .frame(maxWidth: 300, alignment: msg.isUser ? .trailing : .leading)
                                if !msg.isUser { Spacer() }
                            }.id(msg.id)
                        }

                        if vm.isLoading {
                            ProgressView("Assistant typt...")
                                .padding()
                        }
                    }
                    .padding()
                }
                .onChange(of: vm.messages.count) { oldValue, newValue in
                    if let last = vm.messages.last?.id {
                        withAnimation { proxy.scrollTo(last, anchor: .bottom) }
                    }
                }
            }

            HStack {
                TextField("Typ hier je vraag...", text: $vm.userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        Task { await vm.sendMessage() }
                    }

                Button("Verzend") {
                    Task { await vm.sendMessage() }
                }
            }
            .padding()
        }
    }
}