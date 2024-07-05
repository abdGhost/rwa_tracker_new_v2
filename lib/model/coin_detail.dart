class CoinDetail {
  CoinDetail({
    required this.success,
    required this.detail,
  });

  final bool? success;
  final Detail? detail;

  factory CoinDetail.fromJson(Map<String, dynamic> json) {
    return CoinDetail(
      success: json["success"],
      detail: json["detail"] == null ? null : Detail.fromJson(json["detail"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "detail": detail?.toJson(),
      };
}

class Detail {
  Detail({
    required this.id,
    required this.symbol,
    required this.name,
    required this.webSlug,
    required this.assetPlatformId,
    required this.detailPlatforms,
    required this.blockTimeInMinutes,
    required this.hashingAlgorithm,
    required this.categories,
    required this.previewListing,
    required this.publicNotice,
    required this.additionalNotices,
    required this.image,
    required this.countryOrigin,
    required this.genesisDate,
    required this.contractAddress,
    required this.sentimentVotesUpPercentage,
    required this.sentimentVotesDownPercentage,
    required this.watchlistPortfolioUsers,
    required this.marketCapRank,
    required this.marketData,
    required this.communityData,
    required this.developerData,
    required this.statusUpdates,
    required this.lastUpdated,
  });

  final String? id;
  final String? symbol;
  final String? name;
  final String? webSlug;
  final String? assetPlatformId;

  final DetailPlatforms? detailPlatforms;
  final int? blockTimeInMinutes;
  final dynamic hashingAlgorithm;
  final List<String> categories;
  final bool? previewListing;
  final dynamic publicNotice;
  final List<dynamic> additionalNotices;

  final Image? image;
  final String? countryOrigin;
  final dynamic genesisDate;
  final String? contractAddress;
  final double? sentimentVotesUpPercentage;
  final double? sentimentVotesDownPercentage;
  final int? watchlistPortfolioUsers;
  final int? marketCapRank;
  final MarketData? marketData;
  final CommunityData? communityData;
  final DeveloperData? developerData;
  final List<dynamic> statusUpdates;
  final DateTime? lastUpdated;

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      id: json["id"],
      symbol: json["symbol"],
      name: json["name"],
      webSlug: json["web_slug"],
      assetPlatformId: json["asset_platform_id"],
      detailPlatforms: json["detail_platforms"] == null
          ? null
          : DetailPlatforms.fromJson(json["detail_platforms"]),
      blockTimeInMinutes: json["block_time_in_minutes"],
      hashingAlgorithm: json["hashing_algorithm"],
      categories: json["categories"] == null
          ? []
          : List<String>.from(json["categories"].map((x) => x)),
      previewListing: json["preview_listing"],
      publicNotice: json["public_notice"],
      additionalNotices: json["additional_notices"] == null
          ? []
          : List<dynamic>.from(json["additional_notices"].map((x) => x)),
      image: json["image"] == null ? null : Image.fromJson(json["image"]),
      countryOrigin: json["country_origin"],
      genesisDate: json["genesis_date"],
      contractAddress: json["contract_address"],
      sentimentVotesUpPercentage:
          json["sentiment_votes_up_percentage"]?.toDouble(),
      sentimentVotesDownPercentage:
          json["sentiment_votes_down_percentage"]?.toDouble(),
      watchlistPortfolioUsers: json["watchlist_portfolio_users"],
      marketCapRank: json["market_cap_rank"],
      marketData: json["market_data"] == null
          ? null
          : MarketData.fromJson(json["market_data"]),
      communityData: json["community_data"] == null
          ? null
          : CommunityData.fromJson(json["community_data"]),
      developerData: json["developer_data"] == null
          ? null
          : DeveloperData.fromJson(json["developer_data"]),
      statusUpdates: json["status_updates"] == null
          ? []
          : List<dynamic>.from(json["status_updates"].map((x) => x)),
      lastUpdated: DateTime.tryParse(json["last_updated"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "symbol": symbol,
        "name": name,
        "web_slug": webSlug,
        "asset_platform_id": assetPlatformId,
        "detail_platforms": detailPlatforms?.toJson(),
        "block_time_in_minutes": blockTimeInMinutes,
        "hashing_algorithm": hashingAlgorithm,
        "categories": categories.map((x) => x).toList(),
        "preview_listing": previewListing,
        "public_notice": publicNotice,
        "additional_notices": additionalNotices.map((x) => x).toList(),
        "image": image?.toJson(),
        "country_origin": countryOrigin,
        "genesis_date": genesisDate,
        "contract_address": contractAddress,
        "sentiment_votes_up_percentage": sentimentVotesUpPercentage,
        "sentiment_votes_down_percentage": sentimentVotesDownPercentage,
        "watchlist_portfolio_users": watchlistPortfolioUsers,
        "market_cap_rank": marketCapRank,
        "market_data": marketData?.toJson(),
        "community_data": communityData?.toJson(),
        "developer_data": developerData?.toJson(),
        "status_updates": statusUpdates.map((x) => x).toList(),
        "last_updated": lastUpdated?.toIso8601String(),
      };
}

class CommunityData {
  CommunityData({
    required this.facebookLikes,
    required this.twitterFollowers,
    required this.redditAveragePosts48H,
    required this.redditAverageComments48H,
    required this.redditSubscribers,
    required this.redditAccountsActive48H,
    required this.telegramChannelUserCount,
  });

  final dynamic facebookLikes;
  final int? twitterFollowers;
  final int? redditAveragePosts48H;
  final int? redditAverageComments48H;
  final int? redditSubscribers;
  final int? redditAccountsActive48H;
  final int? telegramChannelUserCount;

  factory CommunityData.fromJson(Map<String, dynamic> json) {
    return CommunityData(
      facebookLikes: json["facebook_likes"],
      twitterFollowers: json["twitter_followers"],
      redditAveragePosts48H: json["reddit_average_posts_48h"],
      redditAverageComments48H: json["reddit_average_comments_48h"],
      redditSubscribers: json["reddit_subscribers"],
      redditAccountsActive48H: json["reddit_accounts_active_48h"],
      telegramChannelUserCount: json["telegram_channel_user_count"],
    );
  }

  Map<String, dynamic> toJson() => {
        "facebook_likes": facebookLikes,
        "twitter_followers": twitterFollowers,
        "reddit_average_posts_48h": redditAveragePosts48H,
        "reddit_average_comments_48h": redditAverageComments48H,
        "reddit_subscribers": redditSubscribers,
        "reddit_accounts_active_48h": redditAccountsActive48H,
        "telegram_channel_user_count": telegramChannelUserCount,
      };
}

class DetailPlatforms {
  DetailPlatforms({
    required this.ethereum,
  });

  final Ethereum? ethereum;

  factory DetailPlatforms.fromJson(Map<String, dynamic> json) {
    return DetailPlatforms(
      ethereum:
          json["ethereum"] == null ? null : Ethereum.fromJson(json["ethereum"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "ethereum": ethereum?.toJson(),
      };
}

class Ethereum {
  Ethereum({
    required this.decimalPlace,
    required this.contractAddress,
  });

  final int? decimalPlace;
  final String? contractAddress;

  factory Ethereum.fromJson(Map<String, dynamic> json) {
    return Ethereum(
      decimalPlace: json["decimal_place"],
      contractAddress: json["contract_address"],
    );
  }

  Map<String, dynamic> toJson() => {
        "decimal_place": decimalPlace,
        "contract_address": contractAddress,
      };
}

class DeveloperData {
  DeveloperData({
    required this.forks,
    required this.stars,
    required this.subscribers,
    required this.totalIssues,
    required this.closedIssues,
    required this.pullRequestsMerged,
    required this.pullRequestContributors,
    required this.codeAdditionsDeletions4Weeks,
    required this.commitCount4Weeks,
    required this.last4WeeksCommitActivitySeries,
  });

  final int? forks;
  final int? stars;
  final int? subscribers;
  final int? totalIssues;
  final int? closedIssues;
  final int? pullRequestsMerged;
  final int? pullRequestContributors;
  final CodeAdditionsDeletions4Weeks? codeAdditionsDeletions4Weeks;
  final int? commitCount4Weeks;
  final List<int> last4WeeksCommitActivitySeries;

  factory DeveloperData.fromJson(Map<String, dynamic> json) {
    return DeveloperData(
      forks: json["forks"],
      stars: json["stars"],
      subscribers: json["subscribers"],
      totalIssues: json["total_issues"],
      closedIssues: json["closed_issues"],
      pullRequestsMerged: json["pull_requests_merged"],
      pullRequestContributors: json["pull_request_contributors"],
      codeAdditionsDeletions4Weeks:
          json["code_additions_deletions_4_weeks"] == null
              ? null
              : CodeAdditionsDeletions4Weeks.fromJson(
                  json["code_additions_deletions_4_weeks"]),
      commitCount4Weeks: json["commit_count_4_weeks"],
      last4WeeksCommitActivitySeries:
          json["last_4_weeks_commit_activity_series"] == null
              ? []
              : List<int>.from(
                  json["last_4_weeks_commit_activity_series"].map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "forks": forks,
        "stars": stars,
        "subscribers": subscribers,
        "total_issues": totalIssues,
        "closed_issues": closedIssues,
        "pull_requests_merged": pullRequestsMerged,
        "pull_request_contributors": pullRequestContributors,
        "code_additions_deletions_4_weeks":
            codeAdditionsDeletions4Weeks?.toJson(),
        "commit_count_4_weeks": commitCount4Weeks,
        "last_4_weeks_commit_activity_series":
            last4WeeksCommitActivitySeries.map((x) => x).toList(),
      };
}

class CodeAdditionsDeletions4Weeks {
  CodeAdditionsDeletions4Weeks({
    required this.additions,
    required this.deletions,
  });

  final int? additions;
  final int? deletions;

  factory CodeAdditionsDeletions4Weeks.fromJson(Map<String, dynamic> json) {
    return CodeAdditionsDeletions4Weeks(
      additions: json["additions"],
      deletions: json["deletions"],
    );
  }

  Map<String, dynamic> toJson() => {
        "additions": additions,
        "deletions": deletions,
      };
}

class Image {
  Image({
    required this.thumb,
    required this.small,
    required this.large,
  });

  final String? thumb;
  final String? small;
  final String? large;

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      thumb: json["thumb"],
      small: json["small"],
      large: json["large"],
    );
  }

  Map<String, dynamic> toJson() => {
        "thumb": thumb,
        "small": small,
        "large": large,
      };
}

class Links {
  Links({
    required this.homepage,
    required this.whitepaper,
    required this.blockchainSite,
    required this.officialForumUrl,
    required this.chatUrl,
    required this.announcementUrl,
    required this.twitterScreenName,
    required this.facebookUsername,
    required this.bitcointalkThreadIdentifier,
    required this.telegramChannelIdentifier,
    required this.subredditUrl,
    required this.reposUrl,
  });

  final List<String> homepage;
  final String? whitepaper;
  final List<String> blockchainSite;
  final List<String> officialForumUrl;
  final List<String> chatUrl;
  final List<String> announcementUrl;
  final String? twitterScreenName;
  final String? facebookUsername;
  final dynamic bitcointalkThreadIdentifier;
  final String? telegramChannelIdentifier;
  final String? subredditUrl;
  final ReposUrl? reposUrl;

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      homepage: json["homepage"] == null
          ? []
          : List<String>.from(json["homepage"].map((x) => x)),
      whitepaper: json["whitepaper"],
      blockchainSite: json["blockchain_site"] == null
          ? []
          : List<String>.from(json["blockchain_site"].map((x) => x)),
      officialForumUrl: json["official_forum_url"] == null
          ? []
          : List<String>.from(json["official_forum_url"].map((x) => x)),
      chatUrl: json["chat_url"] == null
          ? []
          : List<String>.from(json["chat_url"].map((x) => x)),
      announcementUrl: json["announcement_url"] == null
          ? []
          : List<String>.from(json["announcement_url"].map((x) => x)),
      twitterScreenName: json["twitter_screen_name"],
      facebookUsername: json["facebook_username"],
      bitcointalkThreadIdentifier: json["bitcointalk_thread_identifier"],
      telegramChannelIdentifier: json["telegram_channel_identifier"],
      subredditUrl: json["subreddit_url"],
      reposUrl: json["repos_url"] == null
          ? null
          : ReposUrl.fromJson(json["repos_url"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "homepage": homepage.map((x) => x).toList(),
        "whitepaper": whitepaper,
        "blockchain_site": blockchainSite.map((x) => x).toList(),
        "official_forum_url": officialForumUrl.map((x) => x).toList(),
        "chat_url": chatUrl.map((x) => x).toList(),
        "announcement_url": announcementUrl.map((x) => x).toList(),
        "twitter_screen_name": twitterScreenName,
        "facebook_username": facebookUsername,
        "bitcointalk_thread_identifier": bitcointalkThreadIdentifier,
        "telegram_channel_identifier": telegramChannelIdentifier,
        "subreddit_url": subredditUrl,
        "repos_url": reposUrl?.toJson(),
      };
}

class ReposUrl {
  ReposUrl({
    required this.github,
    required this.bitbucket,
  });

  final List<String> github;
  final List<dynamic> bitbucket;

  factory ReposUrl.fromJson(Map<String, dynamic> json) {
    return ReposUrl(
      github: json["github"] == null
          ? []
          : List<String>.from(json["github"].map((x) => x)),
      bitbucket: json["bitbucket"] == null
          ? []
          : List<dynamic>.from(json["bitbucket"].map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "github": github.map((x) => x).toList(),
        "bitbucket": bitbucket.map((x) => x).toList(),
      };
}

class MarketData {
  MarketData({
    required this.currentPrice,
    required this.totalValueLocked,
    required this.mcapToTvlRatio,
    required this.fdvToTvlRatio,
    required this.roi,
    this.ath,
    this.athChangePercentage,
    this.athDate,
    this.atl,
    this.atlChangePercentage,
    this.atlDate,
    required this.marketCap,
    required this.marketCapRank,
    required this.fullyDilutedValuation,
    required this.marketCapFdvRatio,
    required this.totalVolume,
    required this.high24H,
    required this.low24H,
    required this.priceChange24H,
    required this.priceChangePercentage24H,
    required this.priceChangePercentage7D,
    required this.priceChangePercentage14D,
    required this.priceChangePercentage30D,
    required this.priceChangePercentage60D,
    required this.priceChangePercentage200D,
    required this.priceChangePercentage1Y,
    required this.marketCapChange24H,
    required this.marketCapChangePercentage24H,
    required this.priceChange24HInCurrency,
    required this.priceChangePercentage1HInCurrency,
    required this.priceChangePercentage24HInCurrency,
    required this.priceChangePercentage7DInCurrency,
    required this.priceChangePercentage14DInCurrency,
    required this.priceChangePercentage30DInCurrency,
    required this.priceChangePercentage60DInCurrency,
    required this.marketCapChange24HInCurrency,
    required this.marketCapChangePercentage24HInCurrency,
    required this.totalSupply,
    required this.maxSupply,
    required this.circulatingSupply,
    required this.lastUpdated,
  });

  final Map<String, dynamic> currentPrice;
  final Map<String, dynamic> totalValueLocked;
  final double? mcapToTvlRatio;
  final double? fdvToTvlRatio;
  final dynamic roi;
  final Map<String, double>? ath;
  final Map<String, double>? athChangePercentage;
  final Map<String, DateTime>? athDate;
  final Map<String, double>? atl;
  final Map<String, double>? atlChangePercentage;
  final Map<String, DateTime>? atlDate;
  final Map<String, double> marketCap;
  final int? marketCapRank;
  final Map<String, double> fullyDilutedValuation;
  final double? marketCapFdvRatio;
  final Map<String, double> totalVolume;
  final Map<String, double> high24H;
  final Map<String, double> low24H;
  final double? priceChange24H;
  final double? priceChangePercentage24H;
  final double? priceChangePercentage7D;
  final double? priceChangePercentage14D;
  final double? priceChangePercentage30D;
  final double? priceChangePercentage60D;
  final double? priceChangePercentage200D;
  final double? priceChangePercentage1Y;
  final double? marketCapChange24H;
  final double? marketCapChangePercentage24H;
  final Map<String, double> priceChange24HInCurrency;
  final Map<String, double> priceChangePercentage1HInCurrency;
  final Map<String, double> priceChangePercentage24HInCurrency;
  final Map<String, double> priceChangePercentage7DInCurrency;
  final Map<String, double> priceChangePercentage14DInCurrency;
  final Map<String, double> priceChangePercentage30DInCurrency;
  final Map<String, double> priceChangePercentage60DInCurrency;

  final Map<String, double> marketCapChange24HInCurrency;
  final Map<String, double> marketCapChangePercentage24HInCurrency;
  final int? totalSupply;
  final int? maxSupply;
  final double? circulatingSupply;
  final DateTime? lastUpdated;

  factory MarketData.fromJson(Map<String, dynamic> json) {
    return MarketData(
      currentPrice: Map.from(json["current_price"]).map(
          (k, v) => MapEntry<String, dynamic>(k, v is int ? v.toDouble() : v)),
      totalValueLocked: Map.from(json["total_value_locked"]).map(
          (k, v) => MapEntry<String, dynamic>(k, v is int ? v.toDouble() : v)),
      mcapToTvlRatio: json["mcap_to_tvl_ratio"]?.toDouble(),
      fdvToTvlRatio: json["fdv_to_tvl_ratio"]?.toDouble(),
      roi: json["roi"],
      ath: Map.from(json["ath"])
          .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
      athChangePercentage: Map.from(json["ath_change_percentage"])
          .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
      marketCap: Map.from(json["market_cap"])
          .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
      marketCapRank: json["market_cap_rank"],
      fullyDilutedValuation: Map.from(json["fully_diluted_valuation"])
          .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
      marketCapFdvRatio: json["market_cap_fdv_ratio"]?.toDouble(),
      totalVolume: Map.from(json["total_volume"])
          .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
      high24H: Map.from(json["high_24h"])
          .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
      low24H: Map.from(json["low_24h"])
          .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
      priceChange24H: json["price_change_24h"]?.toDouble(),
      priceChangePercentage24H: json["price_change_percentage_24h"]?.toDouble(),
      priceChangePercentage7D: json["price_change_percentage_7d"]?.toDouble(),
      priceChangePercentage14D: json["price_change_percentage_14d"]?.toDouble(),
      priceChangePercentage30D: json["price_change_percentage_30d"]?.toDouble(),
      priceChangePercentage60D: json["price_change_percentage_60d"]?.toDouble(),
      priceChangePercentage200D:
          json["price_change_percentage_200d"]?.toDouble(),
      priceChangePercentage1Y: json["price_change_percentage_1y"]?.toDouble(),
      marketCapChange24H: json["market_cap_change_24h"]?.toDouble(),
      marketCapChangePercentage24H:
          json["market_cap_change_percentage_24h"]?.toDouble(),
      priceChange24HInCurrency: Map.from(json["price_change_24h_in_currency"])
          .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
      priceChangePercentage1HInCurrency:
          Map.from(json["price_change_percentage_1h_in_currency"])
              .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
      priceChangePercentage24HInCurrency:
          Map.from(json["price_change_percentage_24h_in_currency"])
              .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
      priceChangePercentage7DInCurrency:
          Map.from(json["price_change_percentage_7d_in_currency"])
              .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
      priceChangePercentage14DInCurrency:
          Map.from(json["price_change_percentage_14d_in_currency"])
              .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
      priceChangePercentage30DInCurrency:
          Map.from(json["price_change_percentage_30d_in_currency"])
              .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
      priceChangePercentage60DInCurrency:
          Map.from(json["price_change_percentage_60d_in_currency"])
              .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
      marketCapChange24HInCurrency:
          Map.from(json["market_cap_change_24h_in_currency"])
              .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
      marketCapChangePercentage24HInCurrency:
          Map.from(json["market_cap_change_percentage_24h_in_currency"])
              .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
      totalSupply: json["total_supply"],
      maxSupply: json["max_supply"],
      circulatingSupply: json["circulating_supply"]?.toDouble(),
      lastUpdated: DateTime.tryParse(json["last_updated"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "current_price": Map.from(currentPrice)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "total_value_locked": Map.from(totalValueLocked)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "mcap_to_tvl_ratio": mcapToTvlRatio,
        "fdv_to_tvl_ratio": fdvToTvlRatio,
        "roi": roi,
        "market_cap":
            Map.from(marketCap).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "market_cap_rank": marketCapRank,
        "fully_diluted_valuation": Map.from(fullyDilutedValuation)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "market_cap_fdv_ratio": marketCapFdvRatio,
        "total_volume": Map.from(totalVolume)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "high_24h":
            Map.from(high24H).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "low_24h":
            Map.from(low24H).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "price_change_24h": priceChange24H,
        "price_change_percentage_24h": priceChangePercentage24H,
        "price_change_percentage_7d": priceChangePercentage7D,
        "price_change_percentage_14d": priceChangePercentage14D,
        "price_change_percentage_30d": priceChangePercentage30D,
        "price_change_percentage_60d": priceChangePercentage60D,
        "price_change_percentage_200d": priceChangePercentage200D,
        "price_change_percentage_1y": priceChangePercentage1Y,
        "market_cap_change_24h": marketCapChange24H,
        "market_cap_change_percentage_24h": marketCapChangePercentage24H,
        "price_change_24h_in_currency": Map.from(priceChange24HInCurrency)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "price_change_percentage_1h_in_currency":
            Map.from(priceChangePercentage1HInCurrency)
                .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "price_change_percentage_24h_in_currency":
            Map.from(priceChangePercentage24HInCurrency)
                .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "price_change_percentage_7d_in_currency":
            Map.from(priceChangePercentage7DInCurrency)
                .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "price_change_percentage_14d_in_currency":
            Map.from(priceChangePercentage14DInCurrency)
                .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "price_change_percentage_30d_in_currency":
            Map.from(priceChangePercentage30DInCurrency)
                .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "price_change_percentage_60d_in_currency":
            Map.from(priceChangePercentage60DInCurrency)
                .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "market_cap_change_24h_in_currency":
            Map.from(marketCapChange24HInCurrency)
                .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "market_cap_change_percentage_24h_in_currency":
            Map.from(marketCapChangePercentage24HInCurrency)
                .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "total_supply": totalSupply,
        "max_supply": maxSupply,
        "circulating_supply": circulatingSupply,
        "last_updated": lastUpdated?.toIso8601String(),
      };
}
