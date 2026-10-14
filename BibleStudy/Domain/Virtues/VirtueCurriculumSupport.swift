import Foundation

enum VirtueCurriculumSources {
    private static let checkedAt = Date(timeIntervalSince1970: 1_791_892_800)

    static let rickaby = source(
        id: "rickaby-four-square",
        title: "Four-Square, or The Cardinal Virtues - Joseph Rickaby, S.J.",
        url: "https://archive.org/details/foursquare00rick",
        locator: "Complete work, especially chapters I-XII (1908); historical secondary source",
        sourceClass: .reviewedSecondary
    )

    static let catechismHumanVirtues = source(
        id: "ccc-human-virtues-study",
        title: "Catechism of the Catholic Church - The Human Virtues",
        url:
            "https://www.vatican.va/content/catechism/en/part_three/section_one/chapter_one/article_7/i_the_human_virtues.index.html",
        locator: "CCC 1803-1811",
        sourceClass: .catechism
    )

    static let catechismTheologicalVirtues = source(
        id: "ccc-theological-virtues-study",
        title: "Catechism of the Catholic Church - The Theological Virtues",
        url:
            "https://www.vatican.va/content/catechism/en/part_three/section_one/chapter_one/article_7/ii_the_theological_virtues.index.html",
        locator: "CCC 1812-1829",
        sourceClass: .catechism
    )

    static let catechismGiftsAndFruits = source(
        id: "ccc-gifts-fruits-study",
        title: "Catechism of the Catholic Church - Gifts and Fruits of the Holy Spirit",
        url:
            "https://www.vatican.va/content/catechism/en/part_three/section_one/chapter_one/article_7/iii_the_gifts_and_fruits_of_the_holy_spirit.html",
        locator: "CCC 1830-1832",
        sourceClass: .catechism
    )

    static let catechismCapitalSins = source(
        id: "ccc-capital-sins-study",
        title: "Catechism of the Catholic Church - The Proliferation of Sin",
        url:
            "https://www.vatican.va/content/catechism/en/part_three/section_one/chapter_one/article_8/v_the_proliferation_of_sin.html",
        locator: "CCC 1865-1869",
        sourceClass: .catechism
    )

    static let catechismBeatitude = source(
        id: "ccc-christian-beatitude-study",
        title: "Catechism of the Catholic Church - Christian Beatitude",
        url:
            "https://www.vatican.va/content/catechism/en/part_three/section_one/chapter_one/article_2/iii_christian_beatitude.html",
        locator: "CCC 1720-1729",
        sourceClass: .catechism
    )

    static let catechismFreedom = source(
        id: "ccc-freedom-responsibility-study",
        title: "Catechism of the Catholic Church - Freedom and Responsibility",
        url:
            "https://www.vatican.va/content/catechism/en/part_three/section_one/chapter_one/article_3/i_freedom_and_responsibility.html",
        locator: "CCC 1730-1748",
        sourceClass: .catechism
    )

    static let catechismPassions = source(
        id: "ccc-passions-study",
        title: "Catechism of the Catholic Church - Passions and Moral Life",
        url:
            "https://www.vatican.va/content/catechism/en/part_three/section_one/chapter_one/article_5/ii_passions_and_moral_life.html",
        locator: "CCC 1762-1775",
        sourceClass: .catechism
    )

    static let catechismGrace = source(
        id: "ccc-grace-study",
        title: "Catechism of the Catholic Church - Grace",
        url:
            "https://www.vatican.va/content/catechism/en/part_three/section_one/chapter_three/article_2/ii_grace.html",
        locator: "CCC 1996-2005",
        sourceClass: .catechism
    )

    static let catechismChastity = source(
        id: "ccc-chastity-study",
        title: "Catechism of the Catholic Church - The Vocation to Chastity",
        url:
            "https://www.vatican.va/content/catechism/en/part_three/section_two/chapter_two/article_6/ii_the_vocation_to_chastity.html",
        locator: "CCC 2337-2359",
        sourceClass: .catechism
    )

    static let catechismPurity = source(
        id: "ccc-purity-study",
        title: "Catechism of the Catholic Church - Purification of the Heart",
        url:
            "https://www.vatican.va/content/catechism/en/part_three/section_two/chapter_two/article_9/i_purification_of_the_heart.html",
        locator: "CCC 2514-2533",
        sourceClass: .catechism
    )

    static let catechismGoodsAndProperty = source(
        id: "ccc-goods-property-study",
        title: "Catechism of the Catholic Church - The Universal Destination of Goods",
        url:
            "https://www.vatican.va/content/catechism/en/part_three/section_two/chapter_two/article_7/i_the_universal_destination_and_the_private_ownership_of_goods.html",
        locator: "CCC 2401-2418",
        sourceClass: .catechism
    )

    static let catechismWork = source(
        id: "ccc-work-study",
        title: "Catechism of the Catholic Church - Economic Activity and Social Justice",
        url:
            "https://www.vatican.va/content/catechism/en/part_three/section_two/chapter_two/article_7/iv_economic_activity_and_social_justice.index.html",
        locator: "CCC 2426-2436",
        sourceClass: .catechism
    )

    static let catechismMercy = source(
        id: "ccc-mercy-study",
        title: "Catechism of the Catholic Church - Love for the Poor",
        url:
            "https://www.vatican.va/content/catechism/en/part_three/section_two/chapter_two/article_7/vi_love_for_the_poor.index.html",
        locator: "CCC 2443-2449",
        sourceClass: .catechism
    )

    static let catechismCovetousness = source(
        id: "ccc-covetousness-study",
        title: "Catechism of the Catholic Church - The Disorder of Covetous Desires",
        url:
            "https://www.vatican.va/content/catechism/en/part_three/section_two/chapter_two/article_10/i_the_disorder_of_covetous_desires.index.html",
        locator: "CCC 2534-2540",
        sourceClass: .catechism
    )

    static let catechismSunday = source(
        id: "ccc-sunday-rest-study",
        title: "Catechism of the Catholic Church - The Lord's Day",
        url:
            "https://www.vatican.va/content/catechism/en/part_three/section_two/chapter_one/article_3/ii_the_lords_day.index.html",
        locator: "CCC 2184-2188",
        sourceClass: .catechism
    )

    static let catechismAnger = source(
        id: "ccc-anger-study",
        title: "Catechism of the Catholic Church - Anger and Hatred",
        url:
            "https://www.vatican.va/content/catechism/en/part_three/section_two/chapter_two/article_5/iii_safeguarding_peace.html",
        locator: "CCC 2302-2303",
        sourceClass: .catechism
    )

    static let catechismHealth = source(
        id: "ccc-health-temperance-study",
        title: "Catechism of the Catholic Church - Respect for Health",
        url:
            "https://www.vatican.va/content/catechism/en/part_three/section_two/chapter_two/article_5/ii_respect_for_the_dignity_of_persons.html",
        locator: "CCC 2288-2291",
        sourceClass: .catechism
    )

    static let catechismPrayerHumility = source(
        id: "ccc-prayer-humility-study",
        title: "Catechism of the Catholic Church - Prayer as God's Gift",
        url:
            "https://www.vatican.va/content/catechism/en/part_four/section_one/chapter_one/article_1/i_prayer_as_gods_gift.html",
        locator: "CCC 2559-2561",
        sourceClass: .catechism
    )

    static let lumenGentium = source(
        id: "vatican-ii-lumen-gentium-holiness",
        title: "Second Vatican Council - Lumen Gentium",
        url:
            "https://www.vatican.va/archive/hist_councils/ii_vatican_council/documents/vat-ii_const_19641121_lumen-gentium_en.html",
        locator: "Lumen Gentium 39-42",
        sourceClass: .universalChurch
    )

    static let gaudete = source(
        id: "pope-francis-gaudete-et-exsultate",
        title: "Pope Francis - Gaudete et Exsultate",
        url:
            "https://www.vatican.va/content/francesco/en/apost_exhortations/documents/papa-francesco_esortazione-ap_20180319_gaudete-et-exsultate.html",
        locator: "Call to holiness, Beatitudes, perseverance, community, prayer, and discernment",
        sourceClass: .universalChurch
    )

    static let deusCaritasEst = source(
        id: "pope-benedict-deus-caritas-est",
        title: "Pope Benedict XVI - Deus Caritas Est",
        url:
            "https://www.vatican.va/content/benedict-xvi/en/encyclicals/documents/hf_ben-xvi_enc_20051225_deus-caritas-est.html",
        locator: "Sections 1-18 and 25-39",
        sourceClass: .universalChurch
    )

    static let popeGrace = audience(
        id: "pope-francis-grace-virtues",
        title: "Pope Francis - The Life of Grace According to the Spirit",
        datePath: "20240424",
        locator: "General Audience, 24 April 2024"
    )

    static let popePrudence = audience(
        id: "pope-francis-prudence",
        title: "Pope Francis - Prudence",
        datePath: "20240320",
        locator: "General Audience, 20 March 2024"
    )

    static let popeJustice = audience(
        id: "pope-francis-justice",
        title: "Pope Francis - Justice",
        datePath: "20240403",
        locator: "General Audience, 3 April 2024"
    )

    static let popeFortitude = audience(
        id: "pope-francis-fortitude",
        title: "Pope Francis - Fortitude",
        datePath: "20240410",
        locator: "General Audience, 10 April 2024"
    )

    static let popeTemperance = audience(
        id: "pope-francis-temperance",
        title: "Pope Francis - Temperance",
        datePath: "20240417",
        locator: "General Audience, 17 April 2024"
    )

    static let popePatience = audience(
        id: "pope-francis-patience",
        title: "Pope Francis - Patience",
        datePath: "20240327",
        locator: "General Audience, 27 March 2024"
    )

    static let popeCharity = audience(
        id: "pope-francis-charity",
        title: "Pope Francis - Charity",
        datePath: "20240515",
        locator: "General Audience, 15 May 2024"
    )

    static let popeHumility = audience(
        id: "pope-francis-humility",
        title: "Pope Francis - Humility",
        datePath: "20240522",
        locator: "General Audience, 22 May 2024"
    )

    static let popePride = audience(
        id: "pope-francis-pride",
        title: "Pope Francis - Pride",
        datePath: "20240306",
        locator: "General Audience, 6 March 2024"
    )

    static let popeEnvy = audience(
        id: "pope-francis-envy",
        title: "Pope Francis - Envy and Vainglory",
        datePath: "20240228",
        locator: "General Audience, 28 February 2024"
    )

    static let popeAcedia = audience(
        id: "pope-francis-acedia",
        title: "Pope Francis - Acedia",
        datePath: "20240214",
        locator: "General Audience, 14 February 2024"
    )

    static let popeWrath = audience(
        id: "pope-francis-wrath",
        title: "Pope Francis - Wrath",
        datePath: "20240131",
        locator: "General Audience, 31 January 2024"
    )

    static let popeAvarice = audience(
        id: "pope-francis-avarice",
        title: "Pope Francis - Avarice",
        datePath: "20240124",
        locator: "General Audience, 24 January 2024"
    )

    static let popeLust = audience(
        id: "pope-francis-lust",
        title: "Pope Francis - Lust",
        datePath: "20240117",
        locator: "General Audience, 17 January 2024"
    )

    static let popeGluttony = audience(
        id: "pope-francis-gluttony",
        title: "Pope Francis - Gluttony",
        datePath: "20240110",
        locator: "General Audience, 10 January 2024"
    )

    private static func audience(
        id: String,
        title: String,
        datePath: String,
        locator: String
    ) -> VirtueContentSource {
        source(
            id: id,
            title: title,
            url:
                "https://www.vatican.va/content/francesco/en/audiences/2024/documents/\(datePath)-udienza-generale.html",
            locator: locator,
            sourceClass: .universalChurch
        )
    }

    private static func source(
        id: String,
        title: String,
        url: String,
        locator: String,
        sourceClass: VirtueSourceClass
    ) -> VirtueContentSource {
        VirtueContentSource(
            id: id,
            title: title,
            url: URL(string: url)!,
            locator: locator,
            sourceClass: sourceClass,
            checkedAt: checkedAt
        )
    }
}

enum VirtueCurriculumBuilder {
    static let draftReview = VirtueContentReview(
        state: .inReview,
        reviewerRole: "Qualified Catholic reviewer pending",
        reviewedAt: nil,
        reviewBy: nil
    )

    static func course(
        id: String,
        collection: VirtueStudyCollection,
        virtueID: VirtueIdentifier?,
        title: String,
        subtitle: String,
        overview: String,
        whyItMatters: String,
        systemImage: String,
        lessons: [VirtueStudyLesson],
        sources: [VirtueContentSource]
    ) -> VirtueStudyCourse {
        VirtueStudyCourse(
            id: id,
            collection: collection,
            virtueID: virtueID,
            title: title,
            subtitle: subtitle,
            overview: overview,
            whyItMatters: whyItMatters,
            systemImage: systemImage,
            contentVersion: 2,
            lessons: lessons,
            sources: sources,
            review: draftReview
        )
    }

    static func lesson(
        id: String,
        title: String,
        summary: String,
        estimatedMinutes: Int = 22,
        terms: [String] = [],
        teaching: String,
        distinction: String,
        witness: String,
        caseStudy: String,
        practice: String,
        prayer: String,
        scripture: [VirtueScriptureEncounter],
        remember: [String],
        sourceIDs: [String]
    ) -> VirtueStudyLesson {
        var sections = [
            section("Core teaching", teaching)
        ]
        if !terms.isEmpty {
            sections.append(section("Terms to know", terms.joined(separator: "\n\n")))
        }
        sections.append(contentsOf: [
            section("See it clearly", distinction),
            section("A Catholic witness", witness),
            section("A case to consider", caseStudy),
            section("Practice before the next lesson", practice),
            section("Prayer", prayer),
        ])
        return VirtueStudyLesson(
            id: id,
            title: title,
            summary: summary,
            estimatedMinutes: estimatedMinutes,
            sections: sections,
            scriptureEncounters: scripture,
            reflectionPrompts: remember,
            sourceIDs: sourceIDs
        )
    }

    static func section(_ title: String, _ body: String) -> VirtueLessonSection {
        VirtueLessonSection(
            id: title.lowercased().replacingOccurrences(of: " ", with: "-"),
            title: title,
            body: body
        )
    }

    static func encounter(
        _ id: String,
        _ title: String,
        _ context: String,
        _ bookID: String,
        _ chapter: Int,
        _ verseStart: Int,
        _ verseEnd: Int
    ) -> VirtueScriptureEncounter {
        VirtueScriptureEncounter(
            id: id,
            title: title,
            context: context,
            reference: try! CanonicalScriptureReference(
                bookID: bookID,
                chapter: chapter,
                verseStart: verseStart,
                verseEnd: verseEnd
            )
        )
    }
}
