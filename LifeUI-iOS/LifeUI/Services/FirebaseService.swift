import Foundation
import FirebaseCore
import FirebaseFirestore

class FirebaseService {
    static let shared = FirebaseService()
    private let db = Firestore.firestore()
    
    private init() {
        // 初始化 Firebase
        FirebaseApp.configure()
    }
    
    // 提交諮詢表單
    func submitInquiry(name: String, phone: String, email: String, type: String, message: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let inquiry = [
            "name": name,
            "phone": phone,
            "email": email,
            "type": type,
            "message": message,
            "timestamp": FieldValue.serverTimestamp(),
            "status": "pending"
        ] as [String : Any]
        
        db.collection("inquiries").addDocument(data: inquiry) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // 獲取所有諮詢記錄
    func getInquiries(completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        db.collection("inquiries")
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                let inquiries = snapshot?.documents.map { $0.data() } ?? []
                completion(.success(inquiries))
            }
    }
} 