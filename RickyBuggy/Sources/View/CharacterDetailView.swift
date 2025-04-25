//
//  CharacterDetailView.swift
//  RickyBuggy
//

import SwiftUI

struct CharacterDetailView: View {
    @ObservedObject private var viewModel: CharacterDetailViewModel
    
    init(viewModel: CharacterDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        content
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: viewModel.requestData) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                    }
                }
            }
    }
}

private extension CharacterDetailView {
    @ViewBuilder var content: some View {
        if viewModel.data != nil {
            ScrollView {
                VStack(alignment: .leading) {
                    photoSection
                    detailsSection
                    locationSection
                }
            }
        } else if viewModel.characterErrors.isEmpty == false {
            FetchRetryView(errors: viewModel.characterErrors, onRetry: viewModel.requestData)
        } else {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .onAppear {
                    viewModel.requestData()
                }
        }
    }
}

// MARK: - Section: Photo

private extension CharacterDetailView {

    var photoSection: some View {
        VStack(alignment: .center, spacing: 8) {
            HStack {
                Spacer()
                CharacterPhoto(data: viewModel.CharacterPhotoData)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: UIScreen.main.bounds.height / 5)
                    .cornerRadius(5)
                Spacer()
            }
        }
        .padding()
    }
}



// MARK: - Section: About

private extension CharacterDetailView {
    var detailsSection: some View {
        VStack(alignment: .center, spacing: 8) {
           
            HStack {
                Text("Popularity level:")
                    .font(.headline)
                Text(viewModel.popularityName)
                    .font(.headline)
            }
            
            Spacer()
            
            Text("About")
                .font(.headline)
            
            Text(viewModel.details)
                .font(.footnote)
                .fontWeight(.medium)
                .padding(.leading, 4)
        }
        .padding()
    }
}

// MARK: - Section: Location

private extension CharacterDetailView {
    var locationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Location")
                    .font(.headline)
                
                Spacer()
                
                Button(action: viewModel.setShowsLocationDetails) {
                    Image(systemName: "square.and.arrow.up.fill")
                        .accentColor(.orange)
                }
            }
        }
        .padding()
        .sheet(isPresented: $viewModel.showsLocationDetailsView) {
            if let locationDetail = viewModel.data?.location {
                VStack(alignment: .leading) {
                    Text(locationDetail.name)
                        .font(.headline)
                    
                    Divider()
                        .padding(.horizontal, 16)
                    
                    Text(locationDetail.created)
                        .font(.headline)
                    
                    
                    Divider()
                        .padding(.horizontal, 16)
                    
                    List(locationDetail.residents, id: \.self) { resident in
                        HStack(alignment: .top) {
                            Text(resident)
                        }
                        
                        Divider()
                            .padding(.horizontal, 16)
                    }
                }
            }
        }
    }
    
    // MARK: - Preview
    
    struct CharacterDetailView_Previews: PreviewProvider {
        static var previews: some View {
            CharacterDetailView(viewModel: CharacterDetailViewModel(characterId: 1, name: "Johnny"))
        }
    }
}
    
