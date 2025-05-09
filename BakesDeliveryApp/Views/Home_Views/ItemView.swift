
import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct ItemView: View {
    var item: Item
    @ObservedObject var HomeModel: HomeViewModel  // Reference to HomeViewModel
    
    var body: some View {
        VStack {
            // Downloading Image From Web...
            WebImage(url: URL(string: item.item_image))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width - 30, height: 400)
                .clipped()
            
            HStack(spacing: 8) {
                // Rating View .....
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: "star.fill")
                        .foregroundColor(index <= Int(item.Item_ratings) ?? 0 ? Color(red: 255 / 255, green: 102 / 255, blue: 0 / 255) : .gray)
                }
                Spacer(minLength: 0)
                
                Text(item.item_name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.trailing)
            }
            
            HStack {
                Text(item.item_description)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.trailing)
                    .lineLimit(2)
                Spacer(minLength: 0)
            }
            
            
            
        }
    }
}


