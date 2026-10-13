import SwiftUI

struct VirtuePathwayView: View {
    let pathway: VirtueFormationPathway
    let openReading: (CanonicalScriptureReference) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: AppSpacing.spacious) {
                introduction
                reviewNotice
                teaching
                scripture
                practices
                examen
                prayer
                pastoralBoundaries
                sources
            }
            .padding()
            .frame(maxWidth: 820)
            .frame(maxWidth: .infinity)
        }
        .background(AppTheme.warmSurface.opacity(0.35))
        .navigationTitle(pathway.title)
        .accessibilityIdentifier("virtue-pathway-detail-\(pathway.id.rawValue)")
    }

    private var introduction: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(pathway.title)
                .font(.system(.largeTitle, design: .serif, weight: .bold))
            Text(pathway.summary)
                .font(AppTypography.screenIntroduction)
                .foregroundStyle(AppTheme.supportingText)
        }
    }

    private var reviewNotice: some View {
        FeatureCard {
            Label("Source-checked draft · Catholic review pending", systemImage: "checkmark.shield")
                .font(.headline)
                .foregroundStyle(AppTheme.warning)
            Text(
                "You can inspect this complete pathway now. It is not marked Catholic-review approved until a qualified reviewer signs and dates the content record."
            )
            .font(.subheadline)
            .foregroundStyle(AppTheme.supportingText)
        }
        .accessibilityIdentifier("virtue-review-status")
    }

    private var teaching: some View {
        section("Understand", systemImage: "book.closed") {
            Text(pathway.teaching)
            Text("How it fits Catholic formation")
                .font(.headline)
                .padding(.top, 4)
            Text(pathway.catholicRelationship)
            Text("What it is not")
                .font(.headline)
                .padding(.top, 4)
            ForEach(pathway.whatItIsNot, id: \.self) { boundary in
                bullet(boundary, systemImage: "xmark.circle")
            }
        }
    }

    private var scripture: some View {
        section("Encounter in Scripture", systemImage: "text.book.closed") {
            ForEach(pathway.scriptureEncounters) { encounter in
                Button {
                    openReading(encounter.reference)
                } label: {
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "book.pages")
                            .foregroundStyle(AppTheme.accent)
                            .frame(width: 28)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(encounter.title)
                                .font(.headline)
                            Text(encounter.reference.displayName)
                                .font(.subheadline.bold())
                                .foregroundStyle(AppTheme.accent)
                            Text(encounter.context)
                                .foregroundStyle(AppTheme.supportingText)
                                .multilineTextAlignment(.leading)
                        }
                        Spacer(minLength: 8)
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("virtue-scripture-\(encounter.id)")
            }
        }
    }

    private var practices: some View {
        section("Practice", systemImage: "figure.walk") {
            Text(
                "Preview these practices. Focus Cycles will let you choose and repeat one without turning formation into a score."
            )
            .font(.subheadline)
            .foregroundStyle(AppTheme.supportingText)
            ForEach(pathway.practices) { practice in
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(practice.title)
                            .font(.headline)
                        Spacer()
                        Text(practice.commitment.title)
                            .font(.caption.bold())
                            .foregroundStyle(AppTheme.accent)
                    }
                    Text(practice.instruction)
                    HStack(spacing: 8) {
                        if let minutes = practice.estimatedMinutes {
                            Label("About \(minutes) min", systemImage: "clock")
                        }
                        Text(practice.contexts.map(\.title).sorted().joined(separator: " · "))
                    }
                    .font(.caption)
                    .foregroundStyle(AppTheme.supportingText)
                }
                .padding(.vertical, 4)
                .accessibilityElement(children: .combine)
            }
        }
        .accessibilityIdentifier("virtue-practices")
    }

    private var examen: some View {
        section("Notice and reflect", systemImage: "sparkles") {
            ForEach(pathway.examenPrompts) { prompt in
                bullet(prompt.text, systemImage: "questionmark.circle")
            }
            Text("These prompts invite honest attention. They do not produce a virtue score or moral judgment.")
                .font(.footnote)
                .foregroundStyle(AppTheme.supportingText)
        }
    }

    private var prayer: some View {
        section("Pray", systemImage: "hands.sparkles") {
            Text(pathway.prayer)
                .font(.system(.body, design: .serif))
                .italic()
        }
    }

    private var pastoralBoundaries: some View {
        section("Pastoral care", systemImage: "heart.text.square") {
            ForEach(pathway.pastoralBoundaries, id: \.self) { boundary in
                bullet(boundary, systemImage: "heart")
            }
        }
    }

    private var sources: some View {
        section("Sources and review", systemImage: "link") {
            ForEach(pathway.sources) { source in
                Link(destination: source.url) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(source.title)
                                .font(.headline)
                                .multilineTextAlignment(.leading)
                            Text(source.locator)
                                .font(.subheadline)
                        }
                        Spacer(minLength: 8)
                        Image(systemName: "arrow.up.right")
                    }
                }
                .accessibilityIdentifier("virtue-source-\(source.id)")
            }
        }
        .accessibilityIdentifier("virtue-sources")
    }

    private func section<Content: View>(
        _ title: String,
        systemImage: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        FeatureCard {
            VStack(alignment: .leading, spacing: 12) {
                Label(title, systemImage: systemImage)
                    .font(AppTypography.sectionTitle)
                content()
            }
        }
    }

    private func bullet(_ text: String, systemImage: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: systemImage)
                .foregroundStyle(AppTheme.accent)
                .frame(width: 22)
            Text(text)
        }
    }
}

extension CanonicalScriptureReference {
    fileprivate var displayName: String {
        let book = CatholicCanon.book(osisID: bookID)?.displayName ?? bookID
        guard let verseStart else { return "\(book) \(chapter)" }
        guard let verseEnd, verseEnd != verseStart else {
            return "\(book) \(chapter):\(verseStart)"
        }
        return "\(book) \(chapter):\(verseStart)–\(verseEnd)"
    }
}
