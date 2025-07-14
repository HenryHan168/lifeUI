import SwiftUI

struct InquiryListView: View {
    @State private var inquiries: [[String: Any]] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView("載入中...")
                } else if let error = errorMessage {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        Text(error)
                            .foregroundColor(.red)
                        Button("重試") {
                            loadInquiries()
                        }
                        .padding()
                    }
                } else {
                    List {
                        ForEach(inquiries, id: \.self) { inquiry in
                            InquiryRow(inquiry: inquiry)
                        }
                    }
                }
            }
            .navigationTitle("諮詢記錄")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: loadInquiries) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
        .onAppear {
            loadInquiries()
        }
    }
    
    private func loadInquiries() {
        isLoading = true
        errorMessage = nil
        
        FirebaseService.shared.getInquiries { result in
            isLoading = false
            
            switch result {
            case .success(let data):
                inquiries = data
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
}

struct InquiryRow: View {
    let inquiry: [String: Any]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(inquiry["name"] as? String ?? "未知")
                    .font(.headline)
                Spacer()
                Text(inquiry["type"] as? String ?? "一般諮詢")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            
            Text(inquiry["phone"] as? String ?? "")
                .font(.subheadline)
            
            if let email = inquiry["email"] as? String, !email.isEmpty {
                Text(email)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Text(inquiry["message"] as? String ?? "")
                .font(.body)
                .lineLimit(2)
            
            if let timestamp = inquiry["timestamp"] as? Date {
                Text(timestamp, style: .date)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }
}

struct InquiryListView_Previews: PreviewProvider {
    static var previews: some View {
        InquiryListView()
    }
} 